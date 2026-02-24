import asyncio
import base64
import json
import uuid
from datetime import UTC, datetime
from typing import Any, Literal

import structlog
from fastapi import (
    APIRouter,
    HTTPException,
    Query,
    WebSocket,
    WebSocketDisconnect,
    status,
)
from google.genai import types as genai_types

from src.common.errors import SVC_001, raise_api_error
from src.lib.ai.orchestrator import GeminiLiveOrchestrator
from src.lib.ai.tools.base import get_tool_definitions, get_tool_handler
from src.lib.auth import decode_token
from src.lib.config import settings
from src.lib.database import async_session_factory
from src.lib.dependencies import CurrentUser
from src.lib.livekit.auth import LiveTokenResponse, create_live_token
from src.lib.livekit.bot import DuckingBotParticipant

logger = structlog.get_logger(__name__)

router = APIRouter()


@router.get("/token", response_model=LiveTokenResponse)
async def get_live_token(
    user: CurrentUser,
    room_name: str = Query(..., min_length=1),
    role: Literal["host", "concierge", "organization", "ai-bridge"] = Query(...),
) -> LiveTokenResponse:
    """Generate a LiveKit access token for the authenticated user."""
    if not settings.LIVEKIT_API_KEY or not settings.LIVEKIT_API_SECRET:
        raise_api_error(SVC_001, status.HTTP_503_SERVICE_UNAVAILABLE)

    identity = f"{role}:{user.id}"
    token = create_live_token(
        room_name=room_name,
        role=role,
        identity=identity,
    )

    return LiveTokenResponse(
        token=token,
        room_name=room_name,
        identity=identity,
        role=role,
    )


@router.websocket("/ws")
async def websocket_gemini_bridge(
    ws: WebSocket,
    token: str = Query(""),
    room: str = Query(""),
) -> None:
    """Bidirectional WebSocket bridge between client and Gemini Live API.

    Requires ``?token=<access_token>`` query parameter for authentication.

    JSON protocol:
      Client -> Server: {"type": "audio|video|text", "data": "...", "text": "..."}
      Server -> Client: {"type": "text|audio|tool_call", ...}
    """
    if not token:
        await ws.close(code=status.WS_1008_POLICY_VIOLATION)
        return

    try:
        payload = decode_token(token)
        if payload.token_type != "access":  # noqa: S105
            await ws.close(code=status.WS_1008_POLICY_VIOLATION)
            return
        if datetime.now(UTC).timestamp() > payload.exp:
            await ws.close(code=status.WS_1008_POLICY_VIOLATION)
            return
        user_id = uuid.UUID(payload.user_id)
        user_role = payload.role
    except (HTTPException, ValueError):
        await ws.close(code=status.WS_1008_POLICY_VIOLATION)
        return

    # Only hosts may open the Gemini bridge; caregivers use LiveKit.
    if user_role != "host":
        await ws.close(code=status.WS_1008_POLICY_VIOLATION)
        return

    await ws.accept()
    logger.info("websocket_authenticated", user_id=str(user_id), role=user_role)

    if not settings.gemini_configured:
        await ws.send_json(
            {"type": "error", "message": "Gemini API is not configured"},
        )
        await ws.close()
        return

    # Set up ducking bot if LiveKit is configured and room is provided
    bot: DuckingBotParticipant | None = None
    if room and settings.LIVEKIT_API_KEY and settings.LIVEKIT_API_SECRET:
        bot = DuckingBotParticipant(room_name=room, host_identity=str(user_id))

    try:
        if bot:
            await bot.connect()

        async with async_session_factory() as db:
            tool_context = {"db": db, "host_id": user_id, "user_role": user_role}
            orchestrator = GeminiLiveOrchestrator(
                tool_definitions=get_tool_definitions(),
                tool_handler=get_tool_handler(context=tool_context),
            )

            async with orchestrator.connect() as session:
                await ws.send_json({"type": "connected"})

                async def client_to_gemini() -> None:
                    """Forward client messages to Gemini Live session."""
                    try:
                        while True:
                            raw = await ws.receive_text()
                            msg = json.loads(raw)
                            msg_type = msg.get("type")

                            if msg_type == "text":
                                content = genai_types.Content(
                                    parts=[genai_types.Part(text=msg.get("text", ""))]
                                )
                                await session.send_client_content(
                                    turns=content,
                                    turn_complete=True,
                                )
                            elif msg_type == "audio":
                                await session.send_realtime_input(
                                    audio=msg.get("data", ""),
                                )
                            elif msg_type == "video":
                                await session.send_realtime_input(
                                    video=msg.get("data", ""),
                                )
                    except WebSocketDisconnect:
                        pass

                async def gemini_to_client() -> None:
                    """Forward Gemini responses to client."""
                    try:
                        async for resp in session.receive():
                            await _forward_response(
                                ws,
                                resp,
                                orchestrator,
                                session,
                                bot=bot,
                                db=db,
                            )
                    except (WebSocketDisconnect, RuntimeError):
                        logger.info("gemini_to_client_ws_closed")
                    except Exception:
                        logger.exception("gemini_receive_error")

                tasks = [
                    asyncio.create_task(client_to_gemini()),
                    asyncio.create_task(gemini_to_client()),
                ]
                try:
                    await asyncio.gather(*tasks)
                finally:
                    for t in tasks:
                        t.cancel()

            await db.commit()

    except WebSocketDisconnect:
        logger.info("websocket_disconnected")
    except Exception:
        logger.exception("websocket_bridge_error")
        try:
            await ws.send_json({"type": "error", "message": "Internal error"})
            await ws.close()
        except Exception:
            logger.debug("websocket_close_failed")
    finally:
        if bot:
            await bot.disconnect()


async def _send_audio(
    ws: WebSocket,
    data: Any,
    *,
    bot: DuckingBotParticipant | None = None,
) -> None:
    """Encode and send audio data, respecting ducking state."""
    if bot and bot.ducking_active.is_set():
        return
    if isinstance(data, bytes):
        data = base64.b64encode(data).decode("ascii")
    await ws.send_json({"type": "audio", "data": data})


async def _forward_response(
    ws: WebSocket,
    response: Any,
    orchestrator: GeminiLiveOrchestrator,
    session: Any,
    *,
    bot: DuckingBotParticipant | None = None,
    db: Any = None,
) -> None:
    """Parse a Gemini response and forward relevant parts.

    When *bot* is provided and ducking is active, audio frames are
    suppressed while text messages pass through.
    """
    if hasattr(response, "tool_call") and response.tool_call:
        await orchestrator.handle_tool_call(session, response)
        if db is not None:
            await db.commit()
        return

    # AI Studio: text arrives directly on response.text
    if hasattr(response, "text") and response.text:
        await ws.send_json({"type": "text", "text": response.text})

    # Vertex AI native audio: content arrives via server_content
    sc = getattr(response, "server_content", None)
    if sc is not None:
        # Transcription of the model's spoken output
        ot = getattr(sc, "output_transcription", None)
        if ot is not None and ot.text:
            await ws.send_json({"type": "text", "text": ot.text})

        # Audio from model_turn parts (primary path for native audio)
        mt = getattr(sc, "model_turn", None)
        if mt is not None:
            for part in getattr(mt, "parts", []):
                inline = getattr(part, "inline_data", None)
                if inline is not None and inline.data:
                    await _send_audio(ws, inline.data, bot=bot)
            return

    # Fallback: SDK convenience property (non-native-audio models)
    if hasattr(response, "data") and response.data:
        await _send_audio(ws, response.data, bot=bot)
