from __future__ import annotations

import uuid
from collections.abc import AsyncGenerator, Generator
from datetime import UTC, datetime
from typing import TYPE_CHECKING, Any
from unittest.mock import AsyncMock, MagicMock, patch

import pytest
from fastapi import HTTPException

from src.common.enums import WellnessStatus
from src.lib.database import get_db
from src.main import app
from src.wellness.model import WellnessLog
from src.wellness.schemas import WellnessLogCreate
from src.wellness.service import (
    create_wellness_log,
    get_wellness_log,
    list_wellness_logs,
)

if TYPE_CHECKING:
    from fastapi.testclient import TestClient

REPO = "src.wellness.repository"
SERVICE = "src.wellness.service"

MOCK_LOG_ID = uuid.UUID("00000000-0000-4000-8000-000000000050")
MOCK_HOST_ID = uuid.UUID("00000000-0000-4000-8000-000000000051")

TEST_USER_ID = "00000000-0000-4000-8000-000000000099"

_NOW = datetime(2026, 1, 1, tzinfo=UTC)


def _mock_wellness_log(**overrides: Any) -> MagicMock:
    defaults: dict[str, Any] = {
        "id": MOCK_LOG_ID,
        "host_id": MOCK_HOST_ID,
        "status": "normal",
        "summary": "All good",
        "details": {},
        "created_at": _NOW,
    }
    defaults.update(overrides)
    return MagicMock(spec=WellnessLog, **defaults)


# ---------------------------------------------------------------------------
# Service Tests
# ---------------------------------------------------------------------------


class TestWellnessService:
    @pytest.mark.asyncio
    @patch(f"{REPO}.create", new_callable=AsyncMock)
    async def test_create_wellness_log(self, mock_create: AsyncMock) -> None:
        mock_create.return_value = MagicMock(spec=WellnessLog)
        db = AsyncMock()
        payload = WellnessLogCreate(
            host_id=uuid.UUID("00000000-0000-4000-8000-000000000050"),
            status=WellnessStatus.WARNING,
            summary="User appeared dizzy",
            details={"location": "kitchen"},
        )
        result = await create_wellness_log(db, payload)
        mock_create.assert_called_once()
        assert result is mock_create.return_value

    @pytest.mark.asyncio
    @patch(f"{REPO}.create", new_callable=AsyncMock)
    async def test_create_wellness_log_normal(self, mock_create: AsyncMock) -> None:
        mock_create.return_value = MagicMock(spec=WellnessLog)
        db = AsyncMock()
        payload = WellnessLogCreate(
            host_id=uuid.UUID("00000000-0000-4000-8000-000000000051"),
            status=WellnessStatus.NORMAL,
            summary="All good",
        )
        result = await create_wellness_log(db, payload)
        mock_create.assert_called_once()
        assert result is mock_create.return_value

    def test_wellness_status_enum(self) -> None:
        assert WellnessStatus.NORMAL.value == "normal"
        assert WellnessStatus.WARNING.value == "warning"
        assert WellnessStatus.EMERGENCY.value == "emergency"

    @pytest.mark.asyncio
    @patch(f"{REPO}.find_by_host", new_callable=AsyncMock)
    async def test_list_wellness_logs(self, mock_find: AsyncMock) -> None:
        logs = [_mock_wellness_log(), _mock_wellness_log()]
        mock_find.return_value = (logs, 2)
        db = AsyncMock()
        result_logs, total = await list_wellness_logs(db, MOCK_HOST_ID)
        assert result_logs == logs
        assert total == 2
        mock_find.assert_called_once_with(db, MOCK_HOST_ID, limit=20, offset=0)

    @pytest.mark.asyncio
    @patch(f"{REPO}.find_by_id", new_callable=AsyncMock)
    async def test_get_wellness_log_found(self, mock_find: AsyncMock) -> None:
        log = _mock_wellness_log()
        mock_find.return_value = log
        db = AsyncMock()
        result = await get_wellness_log(db, MOCK_LOG_ID)
        assert result is log

    @pytest.mark.asyncio
    @patch(f"{REPO}.find_by_id", new_callable=AsyncMock)
    async def test_get_wellness_log_not_found(self, mock_find: AsyncMock) -> None:
        mock_find.return_value = None
        db = AsyncMock()
        result = await get_wellness_log(db, MOCK_LOG_ID)
        assert result is None


# ---------------------------------------------------------------------------
# Router Tests
# ---------------------------------------------------------------------------


class TestWellnessRouter:
    def test_create_wellness_log_unauthenticated(self, client: TestClient) -> None:
        response = client.post(
            "/api/v1/wellness",
            json={
                "host_id": "00000000-0000-4000-8000-000000000052",
                "status": "normal",
                "summary": "All good",
            },
        )
        assert response.status_code == 401

    def test_list_wellness_logs_unauthenticated(self, client: TestClient) -> None:
        response = client.get(
            "/api/v1/wellness",
            params={"host_id": "00000000-0000-4000-8000-000000000053"},
        )
        assert response.status_code == 401


class TestWellnessRouterExtended:
    """Extended router tests with mocked DB and services."""

    @pytest.fixture(autouse=True)
    def _override_db(self) -> Generator[None, None, None]:
        async def _db_override() -> AsyncGenerator[AsyncMock, None]:
            yield AsyncMock()

        app.dependency_overrides[get_db] = _db_override
        yield
        app.dependency_overrides.clear()

    @patch("src.wellness.router.authorize_host_access", new_callable=AsyncMock)
    @patch(f"{SERVICE}.create_wellness_log", new_callable=AsyncMock)
    def test_create_201(
        self,
        mock_create: AsyncMock,
        mock_auth: AsyncMock,
        authed_client: TestClient,
    ) -> None:
        mock_create.return_value = _mock_wellness_log(
            host_id=uuid.UUID(TEST_USER_ID),
        )
        response = authed_client.post(
            "/api/v1/wellness",
            json={
                "host_id": TEST_USER_ID,
                "status": "normal",
                "summary": "All good",
            },
        )
        assert response.status_code == 201
        data = response.json()
        assert data["status"] == "normal"

    @patch("src.wellness.router.authorize_host_access", new_callable=AsyncMock)
    def test_create_403(
        self,
        mock_auth: AsyncMock,
        authed_client: TestClient,
    ) -> None:
        mock_auth.side_effect = HTTPException(status_code=403, detail="Forbidden")
        other_host = "00000000-0000-4000-8000-000000000055"
        response = authed_client.post(
            "/api/v1/wellness",
            json={
                "host_id": other_host,
                "status": "normal",
                "summary": "All good",
            },
        )
        assert response.status_code == 403

    @patch("src.wellness.router.authorize_host_access", new_callable=AsyncMock)
    @patch(f"{SERVICE}.list_wellness_logs", new_callable=AsyncMock)
    def test_list_paginated(
        self,
        mock_list: AsyncMock,
        mock_auth: AsyncMock,
        authed_client: TestClient,
    ) -> None:
        mock_list.return_value = (
            [_mock_wellness_log(host_id=uuid.UUID(TEST_USER_ID))],
            1,
        )
        response = authed_client.get(
            "/api/v1/wellness",
            params={"host_id": TEST_USER_ID, "page": 1, "limit": 10},
        )
        assert response.status_code == 200
        data = response.json()
        assert data["meta"]["total"] == 1
        assert len(data["data"]) == 1

    @patch("src.wellness.router.authorize_host_access", new_callable=AsyncMock)
    @patch(f"{SERVICE}.get_wellness_log", new_callable=AsyncMock)
    def test_get_200(
        self,
        mock_get: AsyncMock,
        mock_auth: AsyncMock,
        authed_client: TestClient,
    ) -> None:
        mock_get.return_value = _mock_wellness_log(
            host_id=uuid.UUID(TEST_USER_ID),
        )
        response = authed_client.get(f"/api/v1/wellness/{MOCK_LOG_ID}")
        assert response.status_code == 200
        assert response.json()["id"] == str(MOCK_LOG_ID)

    @patch(f"{SERVICE}.get_wellness_log", new_callable=AsyncMock)
    def test_get_404(
        self,
        mock_get: AsyncMock,
        authed_client: TestClient,
    ) -> None:
        mock_get.return_value = None
        fake_id = "00000000-0000-4000-8000-000000000060"
        response = authed_client.get(f"/api/v1/wellness/{fake_id}")
        assert response.status_code == 404
