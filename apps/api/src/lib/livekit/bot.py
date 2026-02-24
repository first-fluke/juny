"""LiveKit headless bot participant for audio ducking control."""

import asyncio
import json
from typing import Any

import structlog
from livekit import rtc

from src.lib.config import settings
from src.lib.livekit.auth import create_live_token

logger = structlog.get_logger(__name__)


class DuckingBotParticipant:
    """Headless LiveKit participant that listens for ducking data messages.

    Joins a LiveKit room as ``ai-bridge:{host_id}`` and monitors data channel
    messages with topic ``"ducking"`` to toggle audio suppression.
    """

    def __init__(self, room_name: str, host_identity: str) -> None:
        self.room_name = room_name
        self.host_identity = host_identity
        self.ducking_active = asyncio.Event()
        self._room: Any = None

    async def connect(self) -> None:
        """Connect to the LiveKit room as an ai-bridge participant."""
        identity = f"ai-bridge:{self.host_identity}"
        token = create_live_token(
            room_name=self.room_name,
            role="ai-bridge",
            identity=identity,
        )

        url = settings.LIVEKIT_API_URL
        if not url:
            logger.warning("ducking_bot_no_livekit_url")
            return

        self._room = rtc.Room()
        self._room.on("data_received", self._on_data_received)
        await self._room.connect(url, token)

        logger.info(
            "ducking_bot_connected",
            room=self.room_name,
            identity=identity,
        )

    def _on_data_received(self, data_packet: Any) -> None:
        """Handle incoming data channel messages."""
        try:
            topic = getattr(data_packet, "topic", "")
            if topic != "ducking":
                return

            payload_bytes = getattr(data_packet, "data", b"")
            if isinstance(payload_bytes, bytes):
                payload_bytes = payload_bytes.decode("utf-8")
            payload = json.loads(payload_bytes)

            active = payload.get("active", False)
            if active:
                self.ducking_active.set()
                logger.info("ducking_activated", room=self.room_name)
            else:
                self.ducking_active.clear()
                logger.info("ducking_deactivated", room=self.room_name)
        except (json.JSONDecodeError, AttributeError):
            logger.warning("ducking_invalid_data_packet", room=self.room_name)

    async def disconnect(self) -> None:
        """Disconnect from the LiveKit room."""
        if self._room is not None:
            await self._room.disconnect()
            logger.info("ducking_bot_disconnected", room=self.room_name)
            self._room = None
