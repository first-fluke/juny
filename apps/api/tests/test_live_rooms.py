"""Tests for LiveKit room management endpoints."""

from __future__ import annotations

from collections.abc import AsyncGenerator, Generator
from typing import TYPE_CHECKING
from unittest.mock import AsyncMock, MagicMock, patch

import pytest

from src.lib.database import get_db
from src.main import app

if TYPE_CHECKING:
    from fastapi.testclient import TestClient

LIVE_ROUTER = "src.routers.live"


class TestListRooms:
    @pytest.fixture(autouse=True)
    def _override_db(self) -> Generator[None, None, None]:
        async def _db_override() -> AsyncGenerator[AsyncMock, None]:
            yield AsyncMock()

        app.dependency_overrides[get_db] = _db_override
        yield
        app.dependency_overrides.clear()

    @pytest.mark.filterwarnings(
        "ignore:coroutine 'Connection._cancel' was never awaited:RuntimeWarning"
    )
    @patch(f"{LIVE_ROUTER}._get_livekit_api")
    def test_list_rooms_org_200(
        self,
        mock_api_fn: MagicMock,
        organization_client: TestClient,
    ) -> None:
        mock_api = AsyncMock()
        mock_room = MagicMock()
        mock_room.name = "room-1"
        mock_room.sid = "sid-1"
        mock_room.num_participants = 2
        mock_room.creation_time = 1700000000
        mock_resp = MagicMock()
        mock_resp.rooms = [mock_room]
        mock_api.room.list_rooms = AsyncMock(return_value=mock_resp)
        mock_api.aclose = AsyncMock()
        mock_api_fn.return_value = mock_api

        response = organization_client.get("/api/v1/live/rooms")
        assert response.status_code == 200
        data = response.json()
        assert len(data) == 1
        assert data[0]["name"] == "room-1"
        assert data[0]["num_participants"] == 2

    @patch(f"{LIVE_ROUTER}._get_livekit_api")
    def test_list_rooms_non_org_403(
        self,
        mock_api_fn: MagicMock,
        authed_client: TestClient,
    ) -> None:
        response = authed_client.get("/api/v1/live/rooms")
        assert response.status_code == 403

    @patch(f"{LIVE_ROUTER}._get_livekit_api")
    def test_list_rooms_empty(
        self,
        mock_api_fn: MagicMock,
        organization_client: TestClient,
    ) -> None:
        mock_api = AsyncMock()
        mock_resp = MagicMock()
        mock_resp.rooms = []
        mock_api.room.list_rooms = AsyncMock(return_value=mock_resp)
        mock_api.aclose = AsyncMock()
        mock_api_fn.return_value = mock_api

        response = organization_client.get("/api/v1/live/rooms")
        assert response.status_code == 200
        assert response.json() == []


class TestListParticipants:
    @pytest.fixture(autouse=True)
    def _override_db(self) -> Generator[None, None, None]:
        async def _db_override() -> AsyncGenerator[AsyncMock, None]:
            yield AsyncMock()

        app.dependency_overrides[get_db] = _db_override
        yield
        app.dependency_overrides.clear()

    @patch(f"{LIVE_ROUTER}._get_livekit_api")
    def test_list_participants_200(
        self,
        mock_api_fn: MagicMock,
        organization_client: TestClient,
    ) -> None:
        mock_api = AsyncMock()
        mock_participant = MagicMock()
        mock_participant.identity = "host:user-1"
        mock_participant.name = "Host User"
        mock_participant.state = 1
        mock_participant.joined_at = 1700000000
        mock_resp = MagicMock()
        mock_resp.participants = [mock_participant]
        mock_api.room.list_participants = AsyncMock(return_value=mock_resp)
        mock_api.aclose = AsyncMock()
        mock_api_fn.return_value = mock_api

        response = organization_client.get("/api/v1/live/rooms/test-room/participants")
        assert response.status_code == 200
        data = response.json()
        assert len(data) == 1
        assert data[0]["identity"] == "host:user-1"

    @patch(f"{LIVE_ROUTER}._get_livekit_api")
    def test_list_participants_non_org_403(
        self,
        mock_api_fn: MagicMock,
        authed_client: TestClient,
    ) -> None:
        response = authed_client.get("/api/v1/live/rooms/test-room/participants")
        assert response.status_code == 403
