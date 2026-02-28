"""E2E: Admin endpoints — cleanup, inactive relations, wellness aggregate."""

from datetime import UTC, datetime, timedelta
from unittest.mock import patch

import pytest
from httpx import AsyncClient
from sqlalchemy.ext.asyncio import AsyncSession

from src.notifications.model import DeviceToken
from src.relations.model import CareRelation
from src.users.model import User
from src.wellness.model import WellnessLog
from tests.e2e.conftest import CAREGIVER_USER_ID, HOST_USER_ID

pytestmark = [
    pytest.mark.filterwarnings("ignore::jwt.warnings.InsecureKeyLengthWarning"),
]


# ── Seed helpers ──────────────────────────────────────────────────
async def _seed_host_and_caregiver(db: AsyncSession) -> tuple[User, User]:
    """Insert host + caregiver users."""
    host = User(
        id=HOST_USER_ID,
        email="host-admin@test.com",
        name="Admin Host",
        role="host",
        provider="google",
        provider_id="google-admin-host",
        email_verified=True,
    )
    caregiver = User(
        id=CAREGIVER_USER_ID,
        email="cg-admin@test.com",
        name="Admin Caregiver",
        role="concierge",
        provider="google",
        provider_id="google-admin-cg",
        email_verified=True,
    )
    db.add_all([host, caregiver])
    await db.commit()
    return host, caregiver


# ── Tests ─────────────────────────────────────────────────────────


class TestAdminCleanup:
    async def test_cleanup_deletes_old_wellness_logs(
        self, client: AsyncClient, db_session: AsyncSession
    ) -> None:
        host, _ = await _seed_host_and_caregiver(db_session)

        # Insert old wellness log (120 days ago)
        old_log = WellnessLog(
            host_id=host.id,
            status="normal",
            summary="Old log",
            details={},
            created_at=datetime.now(UTC) - timedelta(days=120),
        )
        # Insert recent wellness log
        new_log = WellnessLog(
            host_id=host.id,
            status="normal",
            summary="Recent log",
            details={},
        )
        db_session.add_all([old_log, new_log])
        await db_session.commit()

        resp = await client.post(
            "/api/v1/admin/cleanup",
            json={"retention_days": 90, "resource_type": "wellness_logs"},
        )
        assert resp.status_code == 200
        data = resp.json()
        assert data["deleted_wellness_logs"] == 1
        assert data["deactivated_tokens"] == 0

    async def test_cleanup_deactivates_old_tokens(
        self, client: AsyncClient, db_session: AsyncSession
    ) -> None:
        host, _ = await _seed_host_and_caregiver(db_session)

        # Insert old device token
        old_token = DeviceToken(
            user_id=host.id,
            token="old-fcm-token-001",  # noqa: S106
            platform="android",
            is_active=True,
            updated_at=datetime.now(UTC) - timedelta(days=100),
        )
        db_session.add(old_token)
        await db_session.commit()

        resp = await client.post(
            "/api/v1/admin/cleanup",
            json={"retention_days": 90, "resource_type": "device_tokens"},
        )
        assert resp.status_code == 200
        data = resp.json()
        assert data["deactivated_tokens"] == 1


class TestAdminInactiveRelations:
    async def test_list_inactive_relations(
        self, client: AsyncClient, db_session: AsyncSession
    ) -> None:
        host, caregiver = await _seed_host_and_caregiver(db_session)

        # Create active relation with no wellness logs → should be inactive
        relation = CareRelation(
            host_id=host.id,
            caregiver_id=caregiver.id,
            role="concierge",
            is_active=True,
        )
        db_session.add(relation)
        await db_session.commit()

        resp = await client.get(
            "/api/v1/admin/inactive-relations",
            params={"threshold_days": 7},
        )
        assert resp.status_code == 200
        data = resp.json()
        assert len(data) >= 1
        found = [r for r in data if r["host_id"] == str(host.id)]
        assert len(found) == 1
        assert found[0]["role"] == "concierge"

    async def test_active_relation_with_recent_log_excluded(
        self, client: AsyncClient, db_session: AsyncSession
    ) -> None:
        host, caregiver = await _seed_host_and_caregiver(db_session)

        relation = CareRelation(
            host_id=host.id,
            caregiver_id=caregiver.id,
            role="concierge",
            is_active=True,
        )
        recent_log = WellnessLog(
            host_id=host.id,
            status="normal",
            summary="Just now",
            details={},
        )
        db_session.add_all([relation, recent_log])
        await db_session.commit()

        resp = await client.get(
            "/api/v1/admin/inactive-relations",
            params={"threshold_days": 7},
        )
        assert resp.status_code == 200
        data = resp.json()
        # Host with recent log should NOT appear
        found = [r for r in data if r["host_id"] == str(host.id)]
        assert len(found) == 0


class TestAdminWellnessAggregate:
    async def test_aggregate_returns_counts_by_status(
        self, client: AsyncClient, db_session: AsyncSession
    ) -> None:
        host, _ = await _seed_host_and_caregiver(db_session)
        today = datetime.now(UTC).strftime("%Y-%m-%d")

        logs = [
            WellnessLog(host_id=host.id, status="normal", summary="ok", details={}),
            WellnessLog(host_id=host.id, status="normal", summary="ok2", details={}),
            WellnessLog(host_id=host.id, status="warning", summary="hmm", details={}),
        ]
        db_session.add_all(logs)
        await db_session.commit()

        resp = await client.get(
            "/api/v1/admin/wellness/aggregate",
            params={"host_id": str(host.id), "date": today},
        )
        assert resp.status_code == 200
        data = resp.json()
        assert data["total_logs"] == 3
        assert data["by_status"]["normal"] == 2
        assert data["by_status"]["warning"] == 1

    async def test_aggregate_empty_date(
        self, client: AsyncClient, db_session: AsyncSession
    ) -> None:
        host, _ = await _seed_host_and_caregiver(db_session)

        resp = await client.get(
            "/api/v1/admin/wellness/aggregate",
            params={"host_id": str(host.id), "date": "2020-01-01"},
        )
        assert resp.status_code == 200
        data = resp.json()
        assert data["total_logs"] == 0
        assert data["by_status"] == {}


class TestAdminAuth:
    @patch("src.lib.internal_auth.settings")
    async def test_missing_key_returns_401_when_configured(
        self, mock_settings: object, client: AsyncClient
    ) -> None:
        """When INTERNAL_API_KEY is set, missing header returns 401."""
        mock_settings.INTERNAL_API_KEY = "e2e-secret"  # type: ignore[attr-defined]
        resp = await client.post(
            "/api/v1/admin/cleanup",
            json={"retention_days": 90},
        )
        assert resp.status_code == 401
