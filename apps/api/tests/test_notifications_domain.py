"""Tests for the notifications domain module (DeviceToken CRUD)."""

from __future__ import annotations

import uuid
from collections.abc import AsyncGenerator, Generator
from typing import TYPE_CHECKING, Any
from unittest.mock import AsyncMock, MagicMock, patch

import pytest

from src.lib.database import get_db
from src.main import app
from src.notifications.model import DeviceToken
from src.notifications.schemas import DeviceTokenCreate
from src.notifications.service import (
    get_user_tokens,
    register_token,
    unregister_token,
)

if TYPE_CHECKING:
    from fastapi.testclient import TestClient

REPO = "src.notifications.repository"

MOCK_USER_ID = uuid.UUID("00000000-0000-4000-8000-000000000099")
MOCK_TOKEN_ID = uuid.UUID("00000000-0000-4000-8000-000000000501")


def _mock_device_token(**overrides: Any) -> MagicMock:
    defaults: dict[str, Any] = {
        "id": MOCK_TOKEN_ID,
        "user_id": MOCK_USER_ID,
        "token": "fcm-token-abc123",
        "platform": "android",
        "is_active": True,
    }
    defaults.update(overrides)
    return MagicMock(spec=DeviceToken, **defaults)


# ---------------------------------------------------------------------------
# Service Tests
# ---------------------------------------------------------------------------


class TestNotificationService:
    @pytest.mark.asyncio
    @patch(f"{REPO}.create", new_callable=AsyncMock)
    @patch(f"{REPO}.find_by_token", new_callable=AsyncMock)
    async def test_register_token_new(
        self, mock_find: AsyncMock, mock_create: AsyncMock
    ) -> None:
        mock_find.return_value = None
        mock_create.return_value = _mock_device_token()
        db = AsyncMock()
        payload = DeviceTokenCreate(token="fcm-token-abc123", platform="android")  # noqa: S106
        result = await register_token(db, MOCK_USER_ID, payload)
        assert result.token == "fcm-token-abc123"  # noqa: S105
        mock_create.assert_called_once()

    @pytest.mark.asyncio
    @patch(f"{REPO}.find_by_token", new_callable=AsyncMock)
    async def test_register_token_existing_reactivate(
        self, mock_find: AsyncMock
    ) -> None:
        existing = _mock_device_token(is_active=False)
        mock_find.return_value = existing
        db = AsyncMock()
        payload = DeviceTokenCreate(token="fcm-token-abc123", platform="android")  # noqa: S106
        result = await register_token(db, MOCK_USER_ID, payload)
        assert result.is_active is True

    @pytest.mark.asyncio
    @patch(f"{REPO}.deactivate", new_callable=AsyncMock)
    @patch(f"{REPO}.find_by_id", new_callable=AsyncMock)
    async def test_unregister_token(
        self, mock_find: AsyncMock, mock_deactivate: AsyncMock
    ) -> None:
        token = _mock_device_token()
        mock_find.return_value = token
        mock_deactivate.return_value = _mock_device_token(is_active=False)
        db = AsyncMock()
        result = await unregister_token(db, MOCK_TOKEN_ID, MOCK_USER_ID)
        assert result is not None
        mock_deactivate.assert_called_once()

    @pytest.mark.asyncio
    @patch(f"{REPO}.find_by_id", new_callable=AsyncMock)
    async def test_unregister_token_not_found(self, mock_find: AsyncMock) -> None:
        mock_find.return_value = None
        db = AsyncMock()
        result = await unregister_token(
            db,
            uuid.UUID("00000000-0000-4000-8000-000000000999"),
            MOCK_USER_ID,
        )
        assert result is None

    @pytest.mark.asyncio
    @patch(f"{REPO}.find_by_id", new_callable=AsyncMock)
    async def test_unregister_token_wrong_owner(self, mock_find: AsyncMock) -> None:
        other_user = uuid.UUID("00000000-0000-4000-8000-000000000070")
        mock_find.return_value = _mock_device_token(user_id=other_user)
        db = AsyncMock()
        result = await unregister_token(db, MOCK_TOKEN_ID, MOCK_USER_ID)
        assert result is None

    @pytest.mark.asyncio
    @patch(f"{REPO}.find_by_user", new_callable=AsyncMock)
    async def test_get_user_tokens(self, mock_find: AsyncMock) -> None:
        mock_find.return_value = [_mock_device_token()]
        db = AsyncMock()
        result = await get_user_tokens(db, MOCK_USER_ID)
        assert len(result) == 1


# ---------------------------------------------------------------------------
# Router Tests
# ---------------------------------------------------------------------------

SERVICE = "src.notifications.service"


class TestNotificationRouter:
    @pytest.fixture(autouse=True)
    def _override_db(self) -> Generator[None, None, None]:
        async def _db_override() -> AsyncGenerator[AsyncMock, None]:
            yield AsyncMock()

        app.dependency_overrides[get_db] = _db_override
        yield
        app.dependency_overrides.clear()

    @patch(f"{SERVICE}.register_token", new_callable=AsyncMock)
    def test_register_device_token_201(
        self,
        mock_register: AsyncMock,
        authed_client: TestClient,
    ) -> None:
        from datetime import UTC, datetime

        mock_register.return_value = _mock_device_token(
            created_at=datetime(2026, 1, 1, tzinfo=UTC),
        )
        response = authed_client.post(
            "/api/v1/notifications/device-tokens",
            json={"token": "fcm-token-abc123", "platform": "android"},
        )
        assert response.status_code == 201
        data = response.json()
        assert data["token"] == "fcm-token-abc123"  # noqa: S105
        assert data["platform"] == "android"

    @patch(f"{SERVICE}.get_user_tokens", new_callable=AsyncMock)
    def test_list_device_tokens_200(
        self,
        mock_list: AsyncMock,
        authed_client: TestClient,
    ) -> None:
        from datetime import UTC, datetime

        mock_list.return_value = [
            _mock_device_token(created_at=datetime(2026, 1, 1, tzinfo=UTC))
        ]
        response = authed_client.get("/api/v1/notifications/device-tokens")
        assert response.status_code == 200
        data = response.json()
        assert len(data) == 1

    @patch(f"{SERVICE}.unregister_token", new_callable=AsyncMock)
    def test_unregister_device_token_204(
        self,
        mock_unregister: AsyncMock,
        authed_client: TestClient,
    ) -> None:
        mock_unregister.return_value = _mock_device_token(is_active=False)
        response = authed_client.delete(
            f"/api/v1/notifications/device-tokens/{MOCK_TOKEN_ID}"
        )
        assert response.status_code == 204

    @patch(f"{SERVICE}.unregister_token", new_callable=AsyncMock)
    def test_unregister_device_token_404(
        self,
        mock_unregister: AsyncMock,
        authed_client: TestClient,
    ) -> None:
        mock_unregister.return_value = None
        response = authed_client.delete(
            f"/api/v1/notifications/device-tokens/{MOCK_TOKEN_ID}"
        )
        assert response.status_code == 404

    def test_register_unauthenticated_401(self, client: TestClient) -> None:
        response = client.post(
            "/api/v1/notifications/device-tokens",
            json={"token": "abc", "platform": "ios"},
        )
        assert response.status_code == 401
