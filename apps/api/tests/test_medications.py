from __future__ import annotations

import uuid
from collections.abc import AsyncGenerator, Generator
from datetime import UTC, datetime
from typing import TYPE_CHECKING, Any
from unittest.mock import AsyncMock, MagicMock, patch

import pytest
from fastapi import HTTPException

from src.lib.database import get_db
from src.main import app
from src.medications.model import Medication
from src.medications.schemas import MedicationCreate, MedicationUpdate
from src.medications.service import (
    create_medication,
    delete_medication,
    get_medication,
    list_medications,
    update_medication,
)

if TYPE_CHECKING:
    from fastapi.testclient import TestClient

REPO = "src.medications.repository"
SERVICE = "src.medications.service"

MOCK_MED_ID = uuid.UUID("00000000-0000-4000-8000-000000000020")
MOCK_HOST_ID = uuid.UUID("00000000-0000-4000-8000-000000000021")

TEST_USER_ID = "00000000-0000-4000-8000-000000000099"

_NOW = datetime(2026, 1, 1, tzinfo=UTC)
_SCHEDULE = datetime(2026, 3, 1, 9, 0, tzinfo=UTC)


def _mock_medication(**overrides: Any) -> MagicMock:
    defaults: dict[str, Any] = {
        "id": MOCK_MED_ID,
        "host_id": MOCK_HOST_ID,
        "pill_name": "Aspirin",
        "schedule_time": _SCHEDULE,
        "is_taken": False,
        "taken_at": None,
        "created_at": _NOW,
    }
    defaults.update(overrides)
    return MagicMock(spec=Medication, **defaults)


# ---------------------------------------------------------------------------
# Service Tests
# ---------------------------------------------------------------------------


class TestMedicationService:
    @pytest.mark.asyncio
    @patch(f"{REPO}.create", new_callable=AsyncMock)
    async def test_create_medication(self, mock_create: AsyncMock) -> None:
        mock_create.return_value = _mock_medication()
        db = AsyncMock()
        payload = MedicationCreate(
            host_id=uuid.UUID("00000000-0000-4000-8000-000000000022"),
            pill_name="Aspirin",
            schedule_time=_SCHEDULE,
        )
        result = await create_medication(db, payload)
        mock_create.assert_called_once()
        assert result is mock_create.return_value

    @pytest.mark.asyncio
    @patch(f"{REPO}.save", new_callable=AsyncMock)
    async def test_update_medication_mark_taken(self, mock_save: AsyncMock) -> None:
        med = _mock_medication()
        mock_save.return_value = med
        db = AsyncMock()
        payload = MedicationUpdate(is_taken=True)
        await update_medication(db, med, payload)
        assert med.is_taken is True
        assert med.taken_at is not None
        mock_save.assert_called_once_with(db, med)

    @pytest.mark.asyncio
    @patch(f"{REPO}.save", new_callable=AsyncMock)
    async def test_update_medication_mark_untaken(self, mock_save: AsyncMock) -> None:
        med = _mock_medication(
            is_taken=True,
            taken_at=datetime.now(UTC),
        )
        mock_save.return_value = med
        db = AsyncMock()
        payload = MedicationUpdate(is_taken=False)
        await update_medication(db, med, payload)
        assert med.is_taken is False
        assert med.taken_at is None

    @pytest.mark.asyncio
    @patch(f"{REPO}.save", new_callable=AsyncMock)
    async def test_update_medication_pill_name(self, mock_save: AsyncMock) -> None:
        med = _mock_medication()
        mock_save.return_value = med
        db = AsyncMock()
        payload = MedicationUpdate(pill_name="Ibuprofen")
        await update_medication(db, med, payload)
        assert med.pill_name == "Ibuprofen"
        mock_save.assert_called_once()

    @pytest.mark.asyncio
    @patch(f"{REPO}.delete", new_callable=AsyncMock)
    async def test_delete_medication(self, mock_delete: AsyncMock) -> None:
        db = AsyncMock()
        med = _mock_medication()
        await delete_medication(db, med)
        mock_delete.assert_called_once_with(db, med)

    @pytest.mark.asyncio
    @patch(f"{REPO}.find_by_host", new_callable=AsyncMock)
    async def test_list_medications(self, mock_find: AsyncMock) -> None:
        meds = [_mock_medication(), _mock_medication()]
        mock_find.return_value = (meds, 2)
        db = AsyncMock()
        result_meds, total = await list_medications(db, MOCK_HOST_ID)
        assert result_meds == meds
        assert total == 2
        mock_find.assert_called_once_with(db, MOCK_HOST_ID, limit=20, offset=0)

    @pytest.mark.asyncio
    @patch(f"{REPO}.find_by_id", new_callable=AsyncMock)
    async def test_get_medication_found(self, mock_find: AsyncMock) -> None:
        med = _mock_medication()
        mock_find.return_value = med
        db = AsyncMock()
        result = await get_medication(db, MOCK_MED_ID)
        assert result is med

    @pytest.mark.asyncio
    @patch(f"{REPO}.find_by_id", new_callable=AsyncMock)
    async def test_get_medication_not_found(self, mock_find: AsyncMock) -> None:
        mock_find.return_value = None
        db = AsyncMock()
        result = await get_medication(db, MOCK_MED_ID)
        assert result is None


# ---------------------------------------------------------------------------
# Router Tests
# ---------------------------------------------------------------------------


class TestMedicationRouter:
    def test_create_medication_unauthenticated(self, client: TestClient) -> None:
        response = client.post(
            "/api/v1/medications",
            json={
                "host_id": "00000000-0000-4000-8000-000000000023",
                "pill_name": "Aspirin",
                "schedule_time": "2026-03-01T09:00:00+00:00",
            },
        )
        assert response.status_code == 401

    def test_list_medications_unauthenticated(self, client: TestClient) -> None:
        response = client.get(
            "/api/v1/medications",
            params={"host_id": "00000000-0000-4000-8000-000000000024"},
        )
        assert response.status_code == 401


class TestMedicationRouterExtended:
    """Extended router tests with mocked DB and services."""

    @pytest.fixture(autouse=True)
    def _override_db(self) -> Generator[None, None, None]:
        async def _db_override() -> AsyncGenerator[AsyncMock, None]:
            yield AsyncMock()

        app.dependency_overrides[get_db] = _db_override
        yield
        app.dependency_overrides.clear()

    @patch("src.medications.router.authorize_host_access", new_callable=AsyncMock)
    @patch(f"{SERVICE}.create_medication", new_callable=AsyncMock)
    def test_create_201(
        self,
        mock_create: AsyncMock,
        mock_auth: AsyncMock,
        authed_client: TestClient,
    ) -> None:
        mock_create.return_value = _mock_medication(
            host_id=uuid.UUID(TEST_USER_ID),
        )
        response = authed_client.post(
            "/api/v1/medications",
            json={
                "host_id": TEST_USER_ID,
                "pill_name": "Aspirin",
                "schedule_time": "2026-03-01T09:00:00+00:00",
            },
        )
        assert response.status_code == 201
        data = response.json()
        assert data["pill_name"] == "Aspirin"

    @patch("src.medications.router.authorize_host_access", new_callable=AsyncMock)
    def test_create_403(
        self,
        mock_auth: AsyncMock,
        authed_client: TestClient,
    ) -> None:
        mock_auth.side_effect = HTTPException(status_code=403, detail="Forbidden")
        other_host = "00000000-0000-4000-8000-000000000055"
        response = authed_client.post(
            "/api/v1/medications",
            json={
                "host_id": other_host,
                "pill_name": "Aspirin",
                "schedule_time": "2026-03-01T09:00:00+00:00",
            },
        )
        assert response.status_code == 403

    @patch("src.medications.router.authorize_host_access", new_callable=AsyncMock)
    @patch(f"{SERVICE}.list_medications", new_callable=AsyncMock)
    def test_list_paginated(
        self,
        mock_list: AsyncMock,
        mock_auth: AsyncMock,
        authed_client: TestClient,
    ) -> None:
        mock_list.return_value = (
            [_mock_medication(host_id=uuid.UUID(TEST_USER_ID))],
            1,
        )
        response = authed_client.get(
            "/api/v1/medications",
            params={"host_id": TEST_USER_ID, "page": 1, "limit": 10},
        )
        assert response.status_code == 200
        data = response.json()
        assert data["meta"]["total"] == 1
        assert len(data["data"]) == 1

    @patch("src.medications.router.authorize_host_access", new_callable=AsyncMock)
    @patch(f"{SERVICE}.get_medication", new_callable=AsyncMock)
    def test_get_200(
        self,
        mock_get: AsyncMock,
        mock_auth: AsyncMock,
        authed_client: TestClient,
    ) -> None:
        mock_get.return_value = _mock_medication(
            host_id=uuid.UUID(TEST_USER_ID),
        )
        response = authed_client.get(f"/api/v1/medications/{MOCK_MED_ID}")
        assert response.status_code == 200
        assert response.json()["id"] == str(MOCK_MED_ID)

    @patch(f"{SERVICE}.get_medication", new_callable=AsyncMock)
    def test_get_404(
        self,
        mock_get: AsyncMock,
        authed_client: TestClient,
    ) -> None:
        mock_get.return_value = None
        fake_id = "00000000-0000-4000-8000-000000000060"
        response = authed_client.get(f"/api/v1/medications/{fake_id}")
        assert response.status_code == 404

    @patch(f"{SERVICE}.delete_medication", new_callable=AsyncMock)
    @patch("src.medications.router.authorize_host_access", new_callable=AsyncMock)
    @patch(f"{SERVICE}.get_medication", new_callable=AsyncMock)
    def test_delete_204(
        self,
        mock_get: AsyncMock,
        mock_auth: AsyncMock,
        mock_delete: AsyncMock,
        authed_client: TestClient,
    ) -> None:
        mock_get.return_value = _mock_medication(
            host_id=uuid.UUID(TEST_USER_ID),
        )
        response = authed_client.delete(f"/api/v1/medications/{MOCK_MED_ID}")
        assert response.status_code == 204
