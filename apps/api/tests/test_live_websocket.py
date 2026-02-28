from __future__ import annotations

from typing import TYPE_CHECKING
from unittest.mock import AsyncMock, MagicMock, patch

import pytest
from starlette.websockets import WebSocketDisconnect

from src.lib.livekit.bot import DuckingBotParticipant

if TYPE_CHECKING:
    from fastapi.testclient import TestClient

_DECODE = "src.routers.live.decode_token"
_SETTINGS = "src.routers.live.settings"
_CREATE_LIVE_TOKEN = "src.routers.live.create_live_token"  # noqa: S105


def _mock_token_payload() -> MagicMock:
    """Return a mock TokenPayload with valid fields."""
    payload = MagicMock()
    payload.user_id = "00000000-0000-4000-8000-000000000001"
    payload.token_type = "access"  # noqa: S105
    payload.exp = 9999999999  # far future
    payload.role = "host"
    return payload


class TestWebSocketBridge:
    """Tests for the WS /api/v1/live/ws endpoint."""

    def test_websocket_rejects_without_token(self, client: TestClient) -> None:
        """When no token is provided, the WS is closed with 1008."""
        with pytest.raises(WebSocketDisconnect) as exc_info:  # noqa: SIM117
            with client.websocket_connect("/api/v1/live/ws"):
                pass
        assert exc_info.value.code == 1008

    @pytest.mark.filterwarnings(
        "ignore:coroutine 'Connection._cancel' was never awaited:RuntimeWarning"
    )
    def test_websocket_rejects_without_gemini_config(self, client: TestClient) -> None:
        """When Gemini is not configured, the WS sends an error and closes."""
        with (
            patch(_DECODE, return_value=_mock_token_payload()),
            patch("src.routers.live.settings") as mock_settings,
        ):
            mock_settings.gemini_configured = False
            with client.websocket_connect("/api/v1/live/ws?token=fake") as ws:
                msg = ws.receive_json()
                assert msg["type"] == "error"
                assert "not configured" in msg["message"]

    @pytest.mark.filterwarnings(
        "ignore:coroutine 'WebSocket.receive_text' was never awaited:RuntimeWarning"
    )
    def test_websocket_sends_connected_on_success(self, client: TestClient) -> None:
        """When Gemini connects successfully, the WS sends a connected message."""
        mock_session = AsyncMock()
        mock_session.receive = MagicMock(return_value=AsyncIteratorMock([]))

        mock_orchestrator_instance = MagicMock()
        mock_cm = AsyncMock()
        mock_cm.__aenter__ = AsyncMock(return_value=mock_session)
        mock_cm.__aexit__ = AsyncMock(return_value=False)
        mock_orchestrator_instance.connect.return_value = mock_cm

        with (
            patch(_DECODE, return_value=_mock_token_payload()),
            patch("src.routers.live.settings") as mock_settings,
            patch(
                "src.routers.live.GeminiLiveOrchestrator",
                return_value=mock_orchestrator_instance,
            ),
        ):
            mock_settings.gemini_configured = True
            with client.websocket_connect("/api/v1/live/ws?token=fake") as ws:
                msg = ws.receive_json()
                assert msg["type"] == "connected"

    def test_websocket_rejects_invalid_token_type(self, client: TestClient) -> None:
        """Token with type=refresh should be rejected with 1008."""
        payload = _mock_token_payload()
        payload.token_type = "refresh"  # noqa: S105
        with (  # noqa: SIM117
            pytest.raises(WebSocketDisconnect) as exc_info,
        ):
            with (
                patch(_DECODE, return_value=payload),
                client.websocket_connect("/api/v1/live/ws?token=fake"),
            ):
                pass
        assert exc_info.value.code == 1008

    @pytest.mark.filterwarnings(
        "ignore:coroutine 'Connection._cancel' was never awaited:RuntimeWarning"
    )
    def test_websocket_rejects_expired_token(self, client: TestClient) -> None:
        """Expired token should be rejected with 1008."""
        payload = _mock_token_payload()
        payload.exp = 0  # already expired
        with (  # noqa: SIM117
            pytest.raises(WebSocketDisconnect) as exc_info,
        ):
            with (
                patch(_DECODE, return_value=payload),
                client.websocket_connect("/api/v1/live/ws?token=fake"),
            ):
                pass
        assert exc_info.value.code == 1008

    def test_websocket_rejects_non_host_role(self, client: TestClient) -> None:
        """Non-host role should be rejected with 1008."""
        payload = _mock_token_payload()
        payload.role = "concierge"
        with (  # noqa: SIM117
            pytest.raises(WebSocketDisconnect) as exc_info,
        ):
            with (
                patch(_DECODE, return_value=payload),
                client.websocket_connect("/api/v1/live/ws?token=fake"),
            ):
                pass
        assert exc_info.value.code == 1008


class TestWebSocketStability:
    """Tests for WebSocket stability: duplicate connections, registry, message size."""

    def test_duplicate_connection_rejected(self, client: TestClient) -> None:
        """Second WS for the same user should receive an error and be closed."""
        from src.routers.live import _active_bridges

        user_key = _mock_token_payload().user_id
        # Simulate an existing active connection
        _active_bridges[user_key] = MagicMock()

        try:
            with (
                patch(_DECODE, return_value=_mock_token_payload()),
                client.websocket_connect("/api/v1/live/ws?token=fake") as ws,
            ):
                msg = ws.receive_json()
                assert msg["type"] == "error"
                assert "Duplicate" in msg["message"]
        finally:
            _active_bridges.pop(user_key, None)

    @pytest.mark.filterwarnings(
        "ignore:coroutine 'Connection._cancel' was never awaited:RuntimeWarning"
    )
    def test_registry_cleaned_on_disconnect(self, client: TestClient) -> None:
        """After WS disconnect, the user should be removed from _active_bridges."""
        from src.routers.live import _active_bridges

        mock_session = AsyncMock()
        mock_session.receive = MagicMock(return_value=AsyncIteratorMock([]))

        mock_orchestrator = MagicMock()
        mock_cm = AsyncMock()
        mock_cm.__aenter__ = AsyncMock(return_value=mock_session)
        mock_cm.__aexit__ = AsyncMock(return_value=False)
        mock_orchestrator.connect.return_value = mock_cm

        user_key = _mock_token_payload().user_id

        with (
            patch(_DECODE, return_value=_mock_token_payload()),
            patch("src.routers.live.settings") as mock_settings,
            patch(
                "src.routers.live.GeminiLiveOrchestrator",
                return_value=mock_orchestrator,
            ),
        ):
            mock_settings.gemini_configured = True
            mock_settings.LIVEKIT_API_KEY = None
            mock_settings.LIVEKIT_API_SECRET = None
            mock_settings.WS_INACTIVITY_TIMEOUT = 1800.0
            mock_settings.WS_MAX_MESSAGE_SIZE = 1_048_576
            mock_settings.WS_PING_INTERVAL = 30.0

            with client.websocket_connect("/api/v1/live/ws?token=fake") as ws:
                msg = ws.receive_json()
                assert msg["type"] == "connected"
                assert user_key in _active_bridges

        assert user_key not in _active_bridges


class TestGetLiveToken:
    """Tests for GET /api/v1/live/token."""

    @patch(_CREATE_LIVE_TOKEN, return_value="mock-jwt-token")
    @patch(_SETTINGS)
    def test_success(
        self,
        mock_settings: MagicMock,
        mock_create: MagicMock,
        authed_client: TestClient,
    ) -> None:
        mock_settings.LIVEKIT_API_KEY = "key"
        mock_settings.LIVEKIT_API_SECRET = "secret"  # noqa: S105
        response = authed_client.get(
            "/api/v1/live/token",
            params={"room_name": "test-room", "role": "host"},
        )
        assert response.status_code == 200
        data = response.json()
        assert data["token"] == "mock-jwt-token"  # noqa: S105
        assert data["room_name"] == "test-room"
        assert data["role"] == "host"

    @patch(_SETTINGS)
    def test_livekit_not_configured_503(
        self,
        mock_settings: MagicMock,
        authed_client: TestClient,
    ) -> None:
        mock_settings.LIVEKIT_API_KEY = None
        mock_settings.LIVEKIT_API_SECRET = None
        response = authed_client.get(
            "/api/v1/live/token",
            params={"room_name": "test-room", "role": "host"},
        )
        assert response.status_code == 503


class TestAudioDucking:
    """Tests for ducking behaviour in _forward_response."""

    @pytest.mark.asyncio
    async def test_ducking_suppresses_audio(self) -> None:
        """When ducking is active, audio data must NOT be forwarded."""
        from src.routers.live import _forward_response

        ws = AsyncMock()
        orchestrator = MagicMock()
        session = AsyncMock()

        bot = DuckingBotParticipant(room_name="room-1", host_identity="user-1")
        bot.ducking_active.set()  # activate ducking

        response = MagicMock()
        response.tool_call = None
        response.text = None
        response.server_content = None
        response.data = b"audio-bytes"

        await _forward_response(ws, response, orchestrator, session, bot=bot)

        ws.send_json.assert_not_called()

    @pytest.mark.asyncio
    async def test_ducking_passes_text(self) -> None:
        """Even when ducking is active, text messages must still pass through."""
        from src.routers.live import _forward_response

        ws = AsyncMock()
        orchestrator = MagicMock()
        session = AsyncMock()

        bot = DuckingBotParticipant(room_name="room-1", host_identity="user-1")
        bot.ducking_active.set()  # activate ducking

        response = MagicMock()
        response.tool_call = None
        response.text = "Hello"
        response.server_content = None
        response.data = None

        await _forward_response(ws, response, orchestrator, session, bot=bot)

        ws.send_json.assert_called_once_with({"type": "text", "text": "Hello"})

    @pytest.mark.asyncio
    async def test_no_ducking_passes_audio(self) -> None:
        """When ducking is NOT active, audio data must be forwarded."""
        from src.routers.live import _forward_response

        ws = AsyncMock()
        orchestrator = MagicMock()
        session = AsyncMock()

        bot = DuckingBotParticipant(room_name="room-1", host_identity="user-1")
        # ducking_active is NOT set (default)

        response = MagicMock()
        response.tool_call = None
        response.text = None
        response.server_content = None
        response.data = b"audio-bytes"

        await _forward_response(ws, response, orchestrator, session, bot=bot)

        ws.send_json.assert_called_once()
        call_args = ws.send_json.call_args[0][0]
        assert call_args["type"] == "audio"


class TestForwardResponseNativeAudio:
    """Tests for native audio extraction in _forward_response."""

    @pytest.mark.asyncio
    async def test_inline_data_audio_forwarded(self) -> None:
        """Audio in server_content.model_turn.parts[].inline_data is forwarded."""
        from src.routers.live import _forward_response

        ws = AsyncMock()
        orchestrator = MagicMock()
        session = AsyncMock()

        inline = MagicMock()
        inline.data = b"native-audio-bytes"

        part = MagicMock()
        part.inline_data = inline

        model_turn = MagicMock()
        model_turn.parts = [part]

        sc = MagicMock()
        sc.output_transcription = None
        sc.model_turn = model_turn

        response = MagicMock()
        response.tool_call = None
        response.text = None
        response.server_content = sc
        response.data = None

        await _forward_response(ws, response, orchestrator, session)

        ws.send_json.assert_called_once()
        call_data = ws.send_json.call_args[0][0]
        assert call_data["type"] == "audio"

    @pytest.mark.asyncio
    async def test_output_transcription_forwarded(self) -> None:
        """Text in server_content.output_transcription is forwarded."""
        from src.routers.live import _forward_response

        ws = AsyncMock()
        orchestrator = MagicMock()
        session = AsyncMock()

        ot = MagicMock()
        ot.text = "Transcribed text"

        sc = MagicMock()
        sc.output_transcription = ot
        sc.model_turn = None

        response = MagicMock()
        response.tool_call = None
        response.text = None
        response.server_content = sc
        response.data = None

        await _forward_response(ws, response, orchestrator, session)

        ws.send_json.assert_called_once_with(
            {"type": "text", "text": "Transcribed text"}
        )

    @pytest.mark.asyncio
    @pytest.mark.filterwarnings(
        "ignore:coroutine 'Connection._cancel' was never awaited:RuntimeWarning"
    )
    async def test_ducking_suppresses_inline_audio(self) -> None:
        """Ducking active should suppress inline_data audio."""
        from src.routers.live import _forward_response

        ws = AsyncMock()
        orchestrator = MagicMock()
        session = AsyncMock()

        bot = DuckingBotParticipant(room_name="room-1", host_identity="user-1")
        bot.ducking_active.set()

        inline = MagicMock()
        inline.data = b"audio-bytes"
        part = MagicMock()
        part.inline_data = inline
        model_turn = MagicMock()
        model_turn.parts = [part]

        sc = MagicMock()
        sc.output_transcription = None
        sc.model_turn = model_turn

        response = MagicMock()
        response.tool_call = None
        response.text = None
        response.server_content = sc
        response.data = None

        await _forward_response(ws, response, orchestrator, session, bot=bot)

        ws.send_json.assert_not_called()


class TestForwardResponseToolCallCommit:
    """Tests for db.commit() after tool call in _forward_response."""

    @pytest.mark.asyncio
    async def test_db_commit_after_tool_call(self) -> None:
        """db.commit() must be called after handle_tool_call."""
        from src.routers.live import _forward_response

        ws = AsyncMock()
        orchestrator = AsyncMock()
        session = AsyncMock()
        db = AsyncMock()

        response = MagicMock()
        response.tool_call = MagicMock()  # truthy tool_call

        await _forward_response(ws, response, orchestrator, session, db=db)

        orchestrator.handle_tool_call.assert_called_once_with(session, response)
        db.commit.assert_called_once()
        ws.send_json.assert_not_called()

    @pytest.mark.asyncio
    async def test_no_db_no_commit(self) -> None:
        """When db is None, commit should not be attempted."""
        from src.routers.live import _forward_response

        ws = AsyncMock()
        orchestrator = AsyncMock()
        session = AsyncMock()

        response = MagicMock()
        response.tool_call = MagicMock()

        await _forward_response(ws, response, orchestrator, session, db=None)

        orchestrator.handle_tool_call.assert_called_once()


class TestDuckingBotParticipant:
    """Unit tests for DuckingBotParticipant."""

    def test_ducking_event_default_unset(self) -> None:
        bot = DuckingBotParticipant(room_name="room-1", host_identity="user-1")
        assert not bot.ducking_active.is_set()

    def test_ducking_toggle(self) -> None:
        bot = DuckingBotParticipant(room_name="room-1", host_identity="user-1")
        bot.ducking_active.set()
        assert bot.ducking_active.is_set()
        bot.ducking_active.clear()
        assert not bot.ducking_active.is_set()


class AsyncIteratorMock:
    """Helper to create an async iterator from a list."""

    def __init__(self, items: list[object]) -> None:
        self._items = iter(items)

    def __aiter__(self) -> AsyncIteratorMock:
        return self

    async def __anext__(self) -> object:
        try:
            return next(self._items)
        except StopIteration:
            raise StopAsyncIteration  # noqa: B904
