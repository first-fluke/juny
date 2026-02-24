from __future__ import annotations

from contextlib import AbstractContextManager
from datetime import timedelta
from typing import Any
from unittest.mock import patch

import jwt
import pytest
from fastapi.testclient import TestClient

from src.lib.livekit.auth import create_live_token


class TestCreateLiveToken:
    """Unit tests for create_live_token()."""

    MOCK_KEY = "test-api-key"
    MOCK_SECRET = "test-api-secret-that-is-long-enough-for-hs256-signing"  # noqa: S105

    def _patch_settings(self, **overrides: str | None) -> AbstractContextManager[Any]:
        defaults: dict[str, Any] = {
            "LIVEKIT_API_KEY": self.MOCK_KEY,
            "LIVEKIT_API_SECRET": self.MOCK_SECRET,
        }
        defaults.update(overrides)
        return patch.multiple(  # type: ignore[no-any-return]
            "src.lib.livekit.auth.settings", **defaults
        )

    def test_create_live_token_host(self) -> None:
        with self._patch_settings():
            token = create_live_token("room-1", "host", "host:user-1")
        assert isinstance(token, str)
        assert len(token) > 0

    def test_create_live_token_concierge(self) -> None:
        with self._patch_settings():
            token = create_live_token("room-1", "concierge", "concierge:user-2")
        assert isinstance(token, str)
        assert len(token) > 0

    def test_create_live_token_missing_config(self) -> None:
        with (
            self._patch_settings(LIVEKIT_API_KEY=None, LIVEKIT_API_SECRET=None),
            pytest.raises(ValueError, match="LIVEKIT_API_KEY"),
        ):
            create_live_token("room-1", "host", "host:user-1")

    def test_host_token_grants(self) -> None:
        with self._patch_settings():
            token = create_live_token(
                "room-1", "host", "host:user-1", ttl=timedelta(hours=1)
            )

        # Decode without verification (we don't have the secret in the right format)
        payload = jwt.decode(token, options={"verify_signature": False})

        video = payload.get("video", {})
        assert video.get("room") == "room-1"
        assert video.get("roomJoin") is True
        assert video.get("canSubscribe") is True
        sources = video.get("canPublishSources", [])
        assert "camera" in sources
        assert "microphone" in sources

    def test_concierge_token_grants(self) -> None:
        with self._patch_settings():
            token = create_live_token("room-1", "concierge", "concierge:user-2")

        payload = jwt.decode(token, options={"verify_signature": False})
        video = payload.get("video", {})
        sources = video.get("canPublishSources", [])
        assert "microphone" in sources
        assert "camera" not in sources

    def test_ai_bridge_token_grants(self) -> None:
        with self._patch_settings():
            token = create_live_token("room-1", "ai-bridge", "ai-bridge:user-1")

        payload = jwt.decode(token, options={"verify_signature": False})
        video = payload.get("video", {})
        assert video.get("canPublish") is False
        assert video.get("canPublishData") is True
        assert video.get("canSubscribe") is True


class TestLiveTokenEndpoint:
    """Integration tests for GET /api/v1/live/token."""

    def test_live_token_endpoint_unauthenticated(self, client: TestClient) -> None:
        response = client.get(
            "/api/v1/live/token",
            params={"room_name": "room-1", "role": "host"},
        )
        assert response.status_code == 401
