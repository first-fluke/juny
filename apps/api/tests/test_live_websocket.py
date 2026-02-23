from __future__ import annotations

from typing import TYPE_CHECKING
from unittest.mock import AsyncMock, MagicMock, patch

import pytest
from starlette.websockets import WebSocketDisconnect

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
