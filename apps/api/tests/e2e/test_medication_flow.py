"""E2E: Medication CRUD — create, list, get, update, delete, authorization."""

from datetime import UTC, datetime

import pytest
from httpx import AsyncClient
from sqlalchemy.ext.asyncio import AsyncSession

from src.relations.model import CareRelation
from src.users.model import User
from tests.e2e.conftest import CAREGIVER_USER_ID, HOST_USER_ID

pytestmark = [
    pytest.mark.filterwarnings("ignore::jwt.warnings.InsecureKeyLengthWarning"),
]

SCHEDULE_TIME = datetime(2026, 3, 1, 9, 0, tzinfo=UTC).isoformat()


@pytest.fixture
async def _relation(
    db_session: AsyncSession, seed_host: User, seed_caregiver: User
) -> CareRelation:
    """Create an active care relation between host and caregiver."""
    relation = CareRelation(
        host_id=HOST_USER_ID,
        caregiver_id=CAREGIVER_USER_ID,
        role="concierge",
    )
    db_session.add(relation)
    await db_session.flush()
    await db_session.refresh(relation)
    return relation


class TestMedicationCRUD:
    async def test_create_medication(
        self, host_client: AsyncClient, seed_host: User
    ) -> None:
        resp = await host_client.post(
            "/api/v1/medications",
            json={
                "host_id": str(seed_host.id),
                "pill_name": "Aspirin",
                "schedule_time": SCHEDULE_TIME,
            },
        )
        assert resp.status_code == 201
        body = resp.json()
        assert body["pill_name"] == "Aspirin"
        assert body["is_taken"] is False
        assert body["taken_at"] is None

    async def test_list_medications_pagination(
        self, host_client: AsyncClient, seed_host: User
    ) -> None:
        host_id = str(seed_host.id)
        for name in ["Med A", "Med B", "Med C"]:
            resp = await host_client.post(
                "/api/v1/medications",
                json={
                    "host_id": host_id,
                    "pill_name": name,
                    "schedule_time": SCHEDULE_TIME,
                },
            )
            assert resp.status_code == 201

        resp = await host_client.get(
            "/api/v1/medications",
            params={"host_id": host_id, "limit": 2},
        )
        assert resp.status_code == 200
        body = resp.json()
        assert len(body["data"]) == 2
        assert body["meta"]["total"] == 3
        assert body["meta"]["page"] == 1

    async def test_get_medication(
        self, host_client: AsyncClient, seed_host: User
    ) -> None:
        create_resp = await host_client.post(
            "/api/v1/medications",
            json={
                "host_id": str(seed_host.id),
                "pill_name": "Vitamin D",
                "schedule_time": SCHEDULE_TIME,
            },
        )
        med_id = create_resp.json()["id"]

        resp = await host_client.get(f"/api/v1/medications/{med_id}")
        assert resp.status_code == 200
        assert resp.json()["pill_name"] == "Vitamin D"

    async def test_update_medication_mark_taken(
        self, host_client: AsyncClient, seed_host: User
    ) -> None:
        create_resp = await host_client.post(
            "/api/v1/medications",
            json={
                "host_id": str(seed_host.id),
                "pill_name": "Omega-3",
                "schedule_time": SCHEDULE_TIME,
            },
        )
        med_id = create_resp.json()["id"]

        resp = await host_client.patch(
            f"/api/v1/medications/{med_id}",
            json={"is_taken": True},
        )
        assert resp.status_code == 200
        body = resp.json()
        assert body["is_taken"] is True
        assert body["taken_at"] is not None

    async def test_delete_medication(
        self, host_client: AsyncClient, seed_host: User
    ) -> None:
        create_resp = await host_client.post(
            "/api/v1/medications",
            json={
                "host_id": str(seed_host.id),
                "pill_name": "Iron",
                "schedule_time": SCHEDULE_TIME,
            },
        )
        med_id = create_resp.json()["id"]

        del_resp = await host_client.delete(f"/api/v1/medications/{med_id}")
        assert del_resp.status_code == 204

        get_resp = await host_client.get(f"/api/v1/medications/{med_id}")
        assert get_resp.status_code == 404


class TestMedicationAuthorization:
    async def test_create_unauthorized(
        self, unrelated_client: AsyncClient, seed_host: User
    ) -> None:
        """A user with no relation to the host should get 403."""
        resp = await unrelated_client.post(
            "/api/v1/medications",
            json={
                "host_id": str(seed_host.id),
                "pill_name": "Blocked Med",
                "schedule_time": SCHEDULE_TIME,
            },
        )
        assert resp.status_code == 403
