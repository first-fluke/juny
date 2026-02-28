from __future__ import annotations

import uuid
from collections.abc import AsyncGenerator, Generator
from datetime import UTC, datetime
from typing import TYPE_CHECKING, Any
from unittest.mock import AsyncMock, MagicMock, patch

import pytest

from src.lib.database import get_db
from src.main import app
from src.notification_logs.model import NotificationLog, NotificationPreference
from src.notification_logs.schemas import NotificationPreferenceUpdate
from src.notification_logs.service import (
    get_log,
    get_preferences,
    list_logs,
    update_log_status,
    update_preferences,
)

if TYPE_CHECKING:
    from fastapi.testclient import TestClient

REPO = "src.notification_logs.repository"
SERVICE = "src.notification_logs.service"

MOCK_LOG_ID = uuid.UUID("00000000-0000-4000-8000-000000000070")
MOCK_USER_ID = uuid.UUID("00000000-0000-4000-8000-000000000071")
MOCK_PREF_ID = uuid.UUID("00000000-0000-4000-8000-000000000072")

TEST_USER_ID = "00000000-0000-4000-8000-000000000099"

_NOW = datetime(2026, 1, 1, tzinfo=UTC)


def _mock_notification_log(**overrides: Any) -> MagicMock:
    defaults: dict[str, Any] = {
        "id": MOCK_LOG_ID,
        "recipient_id": MOCK_USER_ID,
        "title": "Wellness Alert",
        "body": "Emergency detected",
        "status": "sent",
        "channel": "push",
        "metadata_": {},
        "metadata": {},
        "created_at": _NOW,
    }
    defaults.update(overrides)
    return MagicMock(spec=NotificationLog, **defaults)


def _mock_preference(**overrides: Any) -> MagicMock:
    defaults: dict[str, Any] = {
        "id": MOCK_PREF_ID,
        "user_id": MOCK_USER_ID,
        "wellness_alerts": True,
        "medication_reminders": True,
        "system_updates": True,
    }
    defaults.update(overrides)
    return MagicMock(spec=NotificationPreference, **defaults)


# ---------------------------------------------------------------------------
# Service Tests
# ---------------------------------------------------------------------------


class TestNotificationLogService:
    @pytest.mark.asyncio
    @patch(f"{REPO}.find_logs_by_recipient", new_callable=AsyncMock)
    async def test_list_logs(self, mock_find: AsyncMock) -> None:
        logs = [_mock_notification_log(), _mock_notification_log()]
        mock_find.return_value = (logs, 2)
        db = AsyncMock()
        result_logs, total = await list_logs(db, MOCK_USER_ID)
        assert result_logs == logs
        assert total == 2
        mock_find.assert_called_once_with(db, MOCK_USER_ID, limit=20, offset=0)

    @pytest.mark.asyncio
    @patch(f"{REPO}.find_log_by_id", new_callable=AsyncMock)
    async def test_get_log_found(self, mock_find: AsyncMock) -> None:
        log = _mock_notification_log()
        mock_find.return_value = log
        db = AsyncMock()
        result = await get_log(db, MOCK_LOG_ID)
        assert result is log

    @pytest.mark.asyncio
    @patch(f"{REPO}.find_log_by_id", new_callable=AsyncMock)
    async def test_get_log_not_found(self, mock_find: AsyncMock) -> None:
        mock_find.return_value = None
        db = AsyncMock()
        result = await get_log(db, MOCK_LOG_ID)
        assert result is None

    @pytest.mark.asyncio
    @patch(f"{REPO}.save_log", new_callable=AsyncMock)
    async def test_update_log_status(self, mock_save: AsyncMock) -> None:
        log = _mock_notification_log(status="pending")
        mock_save.return_value = log
        db = AsyncMock()
        await update_log_status(db, log, "sent")
        assert log.status == "sent"
        mock_save.assert_called_once_with(db, log)


class TestNotificationPreferenceService:
    @pytest.mark.asyncio
    @patch(f"{REPO}.find_preference_by_user", new_callable=AsyncMock)
    async def test_get_preferences_existing(self, mock_find: AsyncMock) -> None:
        pref = _mock_preference()
        mock_find.return_value = pref
        db = AsyncMock()
        result = await get_preferences(db, MOCK_USER_ID)
        assert result is pref

    @pytest.mark.asyncio
    @patch(f"{REPO}.save_preference", new_callable=AsyncMock)
    @patch(f"{REPO}.find_preference_by_user", new_callable=AsyncMock)
    async def test_get_preferences_creates_default(
        self, mock_find: AsyncMock, mock_save: AsyncMock
    ) -> None:
        mock_find.return_value = None
        new_pref = _mock_preference()
        mock_save.return_value = new_pref
        db = AsyncMock()
        db.add = MagicMock()
        result = await get_preferences(db, MOCK_USER_ID)
        assert result is new_pref
        mock_save.assert_called_once()

    @pytest.mark.asyncio
    @patch(f"{REPO}.save_preference", new_callable=AsyncMock)
    @patch(f"{REPO}.find_preference_by_user", new_callable=AsyncMock)
    async def test_update_preferences(
        self, mock_find: AsyncMock, mock_save: AsyncMock
    ) -> None:
        pref = _mock_preference()
        mock_find.return_value = pref
        mock_save.return_value = pref
        db = AsyncMock()
        payload = NotificationPreferenceUpdate(wellness_alerts=False)
        result = await update_preferences(db, MOCK_USER_ID, payload)
        assert pref.wellness_alerts is False
        assert result is pref


# ---------------------------------------------------------------------------
# Router Tests
# ---------------------------------------------------------------------------


class TestNotificationLogRouter:
    def test_list_unauthenticated(self, client: TestClient) -> None:
        response = client.get("/api/v1/notification-logs")
        assert response.status_code == 401

    def test_preferences_unauthenticated(self, client: TestClient) -> None:
        response = client.get("/api/v1/notification-logs/preferences")
        assert response.status_code == 401


class TestNotificationLogRouterExtended:
    """Extended router tests with mocked DB and services."""

    @pytest.fixture(autouse=True)
    def _override_db(self) -> Generator[None, None, None]:
        async def _db_override() -> AsyncGenerator[AsyncMock, None]:
            yield AsyncMock()

        app.dependency_overrides[get_db] = _db_override
        yield
        app.dependency_overrides.clear()

    @patch(f"{SERVICE}.list_logs", new_callable=AsyncMock)
    def test_list_200(
        self,
        mock_list: AsyncMock,
        authed_client: TestClient,
    ) -> None:
        mock_list.return_value = (
            [_mock_notification_log(recipient_id=uuid.UUID(TEST_USER_ID))],
            1,
        )
        response = authed_client.get(
            "/api/v1/notification-logs",
            params={"page": 1, "limit": 10},
        )
        assert response.status_code == 200
        data = response.json()
        assert data["meta"]["total"] == 1
        assert len(data["data"]) == 1

    @patch(f"{SERVICE}.get_preferences", new_callable=AsyncMock)
    def test_get_preferences_200(
        self,
        mock_get: AsyncMock,
        authed_client: TestClient,
    ) -> None:
        mock_get.return_value = _mock_preference(
            user_id=uuid.UUID(TEST_USER_ID),
        )
        response = authed_client.get("/api/v1/notification-logs/preferences")
        assert response.status_code == 200
        data = response.json()
        assert data["wellness_alerts"] is True

    @patch(f"{SERVICE}.update_preferences", new_callable=AsyncMock)
    def test_update_preferences_200(
        self,
        mock_update: AsyncMock,
        authed_client: TestClient,
    ) -> None:
        mock_update.return_value = _mock_preference(
            user_id=uuid.UUID(TEST_USER_ID),
            wellness_alerts=False,
        )
        response = authed_client.put(
            "/api/v1/notification-logs/preferences",
            json={"wellness_alerts": False},
        )
        assert response.status_code == 200
        data = response.json()
        assert data["wellness_alerts"] is False
