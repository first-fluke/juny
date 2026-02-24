"""E2E: Cross-domain authorization — relation-based access control."""

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
async def active_relation(
    db_session: AsyncSession, seed_host: User, seed_caregiver: User
) -> CareRelation:
    """Create an active care relation between host and caregiver."""
    relation = CareRelation(
        host_id=HOST_USER_ID,
        caregiver_id=CAREGIVER_USER_ID,
        role="concierge",
    )
    db_session.add(relation)
    await db_session.commit()
    await db_session.refresh(relation)
    return relation


class TestCrossDomainAuthorization:
    async def test_caregiver_can_access_host_medications(
        self,
        caregiver_client: AsyncClient,
        seed_host: User,
        active_relation: CareRelation,
    ) -> None:
        """A caregiver with an active relation can create medications for host."""
        resp = await caregiver_client.post(
            "/api/v1/medications",
            json={
                "host_id": str(HOST_USER_ID),
                "pill_name": "Caregiver-Added Med",
                "schedule_time": SCHEDULE_TIME,
            },
        )
        assert resp.status_code == 201
        assert resp.json()["pill_name"] == "Caregiver-Added Med"

    async def test_unrelated_user_cannot_access(
        self,
        unrelated_client: AsyncClient,
        seed_host: User,
        active_relation: CareRelation,
    ) -> None:
        """A user with no relation to the host should get 403."""
        resp = await unrelated_client.post(
            "/api/v1/medications",
            json={
                "host_id": str(HOST_USER_ID),
                "pill_name": "Blocked Med",
                "schedule_time": SCHEDULE_TIME,
            },
        )
        assert resp.status_code == 403

    async def test_deactivated_relation_blocks_access(
        self,
        caregiver_client: AsyncClient,
        seed_host: User,
        active_relation: CareRelation,
        db_session: AsyncSession,
    ) -> None:
        """After deactivation, caregiver should lose access."""
        active_relation.is_active = False
        db_session.add(active_relation)
        await db_session.commit()

        resp = await caregiver_client.post(
            "/api/v1/medications",
            json={
                "host_id": str(HOST_USER_ID),
                "pill_name": "Should Fail",
                "schedule_time": SCHEDULE_TIME,
            },
        )
        assert resp.status_code == 403

    async def test_host_can_access_own_resources(
        self,
        host_client: AsyncClient,
        seed_host: User,
    ) -> None:
        """Host should always be able to access their own resources."""
        resp = await host_client.post(
            "/api/v1/medications",
            json={
                "host_id": str(HOST_USER_ID),
                "pill_name": "Self-Created Med",
                "schedule_time": SCHEDULE_TIME,
            },
        )
        assert resp.status_code == 201
