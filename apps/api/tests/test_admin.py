"""Tests for admin module (internal_auth, service, router)."""

from __future__ import annotations

import uuid
from collections.abc import AsyncGenerator, Generator
from typing import TYPE_CHECKING
from unittest.mock import AsyncMock, MagicMock, patch

import pytest

from src.admin.schemas import (
    CleanupResponse,
    InactiveRelationResponse,
    WellnessAggregateResponse,
)
from src.lib.database import get_db
from src.main import app

if TYPE_CHECKING:
    from fastapi.testclient import TestClient

ADMIN_REPO = "src.admin.repository"
ADMIN_SVC = "src.admin.service"


# ---------------------------------------------------------------------------
# Internal Auth Tests
# ---------------------------------------------------------------------------


class TestInternalAuth:
    """Tests for X-Internal-Key header verification."""

    @pytest.fixture(autouse=True)
    def _override_db(self) -> Generator[None, None, None]:
        async def _db_override() -> AsyncGenerator[AsyncMock, None]:
            yield AsyncMock()

        app.dependency_overrides[get_db] = _db_override
        yield
        app.dependency_overrides.clear()

    @patch(f"{ADMIN_SVC}.cleanup_data", new_callable=AsyncMock)
    def test_no_key_configured_allows_access(
        self,
        mock_cleanup: AsyncMock,
        client: TestClient,
    ) -> None:
        """When INTERNAL_API_KEY is None, requests pass through."""
        mock_cleanup.return_value = CleanupResponse(
            deleted_wellness_logs=0, deactivated_tokens=0
        )
        response = client.post(
            "/api/v1/admin/cleanup",
            json={"retention_days": 90},
        )
        assert response.status_code == 200

    @patch("src.lib.internal_auth.settings")
    @patch(f"{ADMIN_SVC}.cleanup_data", new_callable=AsyncMock)
    def test_valid_key_allows_access(
        self,
        mock_cleanup: AsyncMock,
        mock_settings: MagicMock,
        client: TestClient,
    ) -> None:
        mock_settings.INTERNAL_API_KEY = "test-secret-key"
        mock_cleanup.return_value = CleanupResponse(
            deleted_wellness_logs=0, deactivated_tokens=0
        )
        response = client.post(
            "/api/v1/admin/cleanup",
            json={"retention_days": 90},
            headers={"X-Internal-Key": "test-secret-key"},
        )
        assert response.status_code == 200

    @patch("src.lib.internal_auth.settings")
    def test_invalid_key_returns_401(
        self,
        mock_settings: MagicMock,
        client: TestClient,
    ) -> None:
        mock_settings.INTERNAL_API_KEY = "test-secret-key"
        response = client.post(
            "/api/v1/admin/cleanup",
            json={"retention_days": 90},
            headers={"X-Internal-Key": "wrong-key"},
        )
        assert response.status_code == 401

    @patch("src.lib.internal_auth.settings")
    def test_missing_key_returns_401(
        self,
        mock_settings: MagicMock,
        client: TestClient,
    ) -> None:
        mock_settings.INTERNAL_API_KEY = "test-secret-key"
        response = client.post(
            "/api/v1/admin/cleanup",
            json={"retention_days": 90},
        )
        assert response.status_code == 401


# ---------------------------------------------------------------------------
# Service Tests
# ---------------------------------------------------------------------------


class TestAdminService:
    """Tests for admin service functions."""

    @pytest.mark.asyncio
    @patch(f"{ADMIN_REPO}.create_audit_log", new_callable=AsyncMock)
    @patch(f"{ADMIN_REPO}.delete_old_wellness_logs", new_callable=AsyncMock)
    @patch(f"{ADMIN_REPO}.deactivate_old_tokens", new_callable=AsyncMock)
    async def test_cleanup_all(
        self,
        mock_deactivate: AsyncMock,
        mock_delete_logs: AsyncMock,
        mock_audit: AsyncMock,
    ) -> None:
        from src.admin.service import cleanup_data

        mock_delete_logs.return_value = 5
        mock_deactivate.return_value = 2
        db = AsyncMock()
        db.add = MagicMock()

        result = await cleanup_data(db, retention_days=90, resource_type="all")

        assert result.deleted_wellness_logs == 5
        assert result.deactivated_tokens == 2
        mock_delete_logs.assert_called_once()
        mock_deactivate.assert_called_once()
        mock_audit.assert_called_once()
        db.commit.assert_called_once()

    @pytest.mark.asyncio
    @patch(f"{ADMIN_REPO}.create_audit_log", new_callable=AsyncMock)
    @patch(f"{ADMIN_REPO}.delete_old_wellness_logs", new_callable=AsyncMock)
    @patch(f"{ADMIN_REPO}.deactivate_old_tokens", new_callable=AsyncMock)
    async def test_cleanup_wellness_logs_only(
        self,
        mock_deactivate: AsyncMock,
        mock_delete_logs: AsyncMock,
        mock_audit: AsyncMock,
    ) -> None:
        from src.admin.service import cleanup_data

        mock_delete_logs.return_value = 3
        db = AsyncMock()
        db.add = MagicMock()

        result = await cleanup_data(
            db, retention_days=90, resource_type="wellness_logs"
        )

        assert result.deleted_wellness_logs == 3
        assert result.deactivated_tokens == 0
        mock_delete_logs.assert_called_once()
        mock_deactivate.assert_not_called()

    @pytest.mark.asyncio
    @patch(f"{ADMIN_REPO}.create_audit_log", new_callable=AsyncMock)
    @patch(f"{ADMIN_REPO}.delete_old_wellness_logs", new_callable=AsyncMock)
    @patch(f"{ADMIN_REPO}.deactivate_old_tokens", new_callable=AsyncMock)
    async def test_cleanup_device_tokens_only(
        self,
        mock_deactivate: AsyncMock,
        mock_delete_logs: AsyncMock,
        mock_audit: AsyncMock,
    ) -> None:
        from src.admin.service import cleanup_data

        mock_deactivate.return_value = 4
        db = AsyncMock()
        db.add = MagicMock()

        result = await cleanup_data(
            db, retention_days=30, resource_type="device_tokens"
        )

        assert result.deleted_wellness_logs == 0
        assert result.deactivated_tokens == 4
        mock_delete_logs.assert_not_called()
        mock_deactivate.assert_called_once()

    @pytest.mark.asyncio
    @patch(f"{ADMIN_REPO}.find_inactive_relations", new_callable=AsyncMock)
    async def test_get_inactive_relations(
        self,
        mock_find: AsyncMock,
    ) -> None:
        from src.admin.service import get_inactive_relations

        relation_id = uuid.UUID("00000000-0000-4000-8000-000000000201")
        host_id = uuid.UUID("00000000-0000-4000-8000-000000000202")
        caregiver_id = uuid.UUID("00000000-0000-4000-8000-000000000203")
        mock_row = MagicMock()
        mock_row.relation_id = relation_id
        mock_row.host_id = host_id
        mock_row.caregiver_id = caregiver_id
        mock_row.role = "concierge"
        mock_row.last_wellness_at = None
        mock_row.inactive_days = 45
        mock_find.return_value = [mock_row]

        db = AsyncMock()
        result = await get_inactive_relations(db, threshold_days=30)

        assert len(result) == 1
        assert result[0].relation_id == relation_id
        assert result[0].inactive_days == 45

    @pytest.mark.asyncio
    @patch(f"{ADMIN_REPO}.find_inactive_relations", new_callable=AsyncMock)
    async def test_get_inactive_relations_empty(
        self,
        mock_find: AsyncMock,
    ) -> None:
        from src.admin.service import get_inactive_relations

        mock_find.return_value = []
        db = AsyncMock()
        result = await get_inactive_relations(db, threshold_days=30)
        assert result == []

    @pytest.mark.asyncio
    @patch(f"{ADMIN_REPO}.aggregate_wellness", new_callable=AsyncMock)
    async def test_get_wellness_aggregate(
        self,
        mock_agg: AsyncMock,
    ) -> None:
        from src.admin.service import get_wellness_aggregate

        host_id = uuid.UUID("00000000-0000-4000-8000-000000000301")
        mock_agg.return_value = {"normal": 5, "warning": 1}
        db = AsyncMock()

        result = await get_wellness_aggregate(db, host_id, "2026-01-15")

        assert result.total_logs == 6
        assert result.by_status == {"normal": 5, "warning": 1}
        assert result.date == "2026-01-15"

    @pytest.mark.asyncio
    @patch(f"{ADMIN_REPO}.create_audit_log", new_callable=AsyncMock)
    @patch("src.notifications.repository.deactivate_tokens", new_callable=AsyncMock)
    async def test_deactivate_failed_tokens(
        self,
        mock_deactivate: AsyncMock,
        mock_audit: AsyncMock,
    ) -> None:
        from src.admin.service import deactivate_failed_tokens

        mock_deactivate.return_value = 2
        db = AsyncMock()
        db.add = MagicMock()

        result = await deactivate_failed_tokens(db, ["tok-a", "tok-b"])

        assert result == 2
        mock_deactivate.assert_called_once_with(db, ["tok-a", "tok-b"])
        mock_audit.assert_called_once()
        db.commit.assert_called_once()

    @pytest.mark.asyncio
    async def test_deactivate_failed_tokens_empty_list(self) -> None:
        from src.admin.service import deactivate_failed_tokens

        db = AsyncMock()
        result = await deactivate_failed_tokens(db, [])

        assert result == 0
        db.commit.assert_not_called()

    @pytest.mark.asyncio
    @patch(f"{ADMIN_REPO}.aggregate_wellness", new_callable=AsyncMock)
    async def test_get_wellness_aggregate_no_data(
        self,
        mock_agg: AsyncMock,
    ) -> None:
        from src.admin.service import get_wellness_aggregate

        host_id = uuid.UUID("00000000-0000-4000-8000-000000000302")
        mock_agg.return_value = {}
        db = AsyncMock()

        result = await get_wellness_aggregate(db, host_id, "2026-01-20")

        assert result.total_logs == 0
        assert result.by_status == {}

    @pytest.mark.asyncio
    @patch(f"{ADMIN_REPO}.find_audit_logs", new_callable=AsyncMock)
    async def test_list_audit_logs(
        self,
        mock_find: AsyncMock,
    ) -> None:
        from src.admin.service import list_audit_logs

        mock_log = MagicMock()
        mock_log.id = uuid.UUID("00000000-0000-4000-8000-000000000601")
        mock_log.action = "cleanup"
        mock_find.return_value = ([mock_log], 1)

        db = AsyncMock()
        logs, total = await list_audit_logs(db, limit=50, offset=0)

        assert total == 1
        assert len(logs) == 1
        mock_find.assert_called_once_with(db, limit=50, offset=0)

    @pytest.mark.asyncio
    @patch(f"{ADMIN_REPO}.find_audit_logs", new_callable=AsyncMock)
    async def test_list_audit_logs_empty(
        self,
        mock_find: AsyncMock,
    ) -> None:
        from src.admin.service import list_audit_logs

        mock_find.return_value = ([], 0)
        db = AsyncMock()

        logs, total = await list_audit_logs(db, limit=50, offset=0)

        assert total == 0
        assert logs == []

    @pytest.mark.asyncio
    @patch("src.notifications.repository.find_by_user", new_callable=AsyncMock)
    @patch("src.medications.repository.find_by_host", new_callable=AsyncMock)
    @patch("src.wellness.repository.find_by_host", new_callable=AsyncMock)
    @patch("src.relations.repository.find_by_caregiver", new_callable=AsyncMock)
    @patch("src.relations.repository.find_by_host", new_callable=AsyncMock)
    @patch("src.users.repository.find_by_id", new_callable=AsyncMock)
    async def test_export_user_data(
        self,
        mock_user: AsyncMock,
        mock_rel_host: AsyncMock,
        mock_rel_cg: AsyncMock,
        mock_wellness: AsyncMock,
        mock_meds: AsyncMock,
        mock_tokens: AsyncMock,
    ) -> None:
        from src.admin.service import export_user_data

        user_id = uuid.UUID("00000000-0000-4000-8000-000000000801")
        mock_user_obj = MagicMock()
        mock_user_obj.email = "test@example.com"
        mock_user.return_value = mock_user_obj
        mock_rel_host.return_value = ([], 0)
        mock_rel_cg.return_value = ([], 0)
        mock_wellness.return_value = ([], 0)
        mock_meds.return_value = ([], 0)
        mock_tokens.return_value = []

        db = AsyncMock()
        result = await export_user_data(db, user_id)

        assert "user" in result
        assert "relations_as_host" in result
        assert "wellness_logs" in result
        assert "medications" in result
        assert "device_tokens" in result

    @pytest.mark.asyncio
    @patch("src.users.repository.find_by_id", new_callable=AsyncMock)
    async def test_export_user_data_not_found(
        self,
        mock_user: AsyncMock,
    ) -> None:
        from src.admin.service import export_user_data

        mock_user.return_value = None
        db = AsyncMock()

        result = await export_user_data(
            db, uuid.UUID("00000000-0000-4000-8000-000000000899")
        )
        assert result == {}


# ---------------------------------------------------------------------------
# Router Tests
# ---------------------------------------------------------------------------


class TestAdminRouter:
    """Tests for admin router endpoints."""

    @pytest.fixture(autouse=True)
    def _override_db(self) -> Generator[None, None, None]:
        async def _db_override() -> AsyncGenerator[AsyncMock, None]:
            yield AsyncMock()

        app.dependency_overrides[get_db] = _db_override
        yield
        app.dependency_overrides.clear()

    @patch(f"{ADMIN_SVC}.cleanup_data", new_callable=AsyncMock)
    def test_cleanup_endpoint(
        self,
        mock_cleanup: AsyncMock,
        client: TestClient,
    ) -> None:
        mock_cleanup.return_value = CleanupResponse(
            deleted_wellness_logs=10, deactivated_tokens=3
        )
        response = client.post(
            "/api/v1/admin/cleanup",
            json={"retention_days": 60, "resource_type": "all"},
        )
        assert response.status_code == 200
        data = response.json()
        assert data["deleted_wellness_logs"] == 10
        assert data["deactivated_tokens"] == 3

    @patch(f"{ADMIN_SVC}.get_inactive_relations", new_callable=AsyncMock)
    def test_inactive_relations_endpoint(
        self,
        mock_inactive: AsyncMock,
        client: TestClient,
    ) -> None:
        mock_inactive.return_value = [
            InactiveRelationResponse(
                relation_id=uuid.UUID("00000000-0000-4000-8000-000000000401"),
                host_id=uuid.UUID("00000000-0000-4000-8000-000000000402"),
                caregiver_id=uuid.UUID("00000000-0000-4000-8000-000000000403"),
                role="concierge",
                last_wellness_at=None,
                inactive_days=40,
            )
        ]
        response = client.get(
            "/api/v1/admin/inactive-relations",
            params={"threshold_days": 30},
        )
        assert response.status_code == 200
        data = response.json()
        assert len(data) == 1
        assert data[0]["inactive_days"] == 40

    @patch(f"{ADMIN_SVC}.get_wellness_aggregate", new_callable=AsyncMock)
    def test_wellness_aggregate_endpoint(
        self,
        mock_agg: AsyncMock,
        client: TestClient,
    ) -> None:
        host_id = uuid.UUID("00000000-0000-4000-8000-000000000501")
        mock_agg.return_value = WellnessAggregateResponse(
            host_id=host_id,
            date="2026-01-15",
            total_logs=6,
            by_status={"normal": 5, "warning": 1},
        )
        response = client.get(
            "/api/v1/admin/wellness/aggregate",
            params={"host_id": str(host_id), "date": "2026-01-15"},
        )
        assert response.status_code == 200
        data = response.json()
        assert data["total_logs"] == 6
        assert data["by_status"]["normal"] == 5

    def test_wellness_aggregate_missing_params(
        self,
        client: TestClient,
    ) -> None:
        response = client.get("/api/v1/admin/wellness/aggregate")
        assert response.status_code == 422

    @patch(f"{ADMIN_SVC}.deactivate_failed_tokens", new_callable=AsyncMock)
    def test_deactivate_tokens_endpoint(
        self,
        mock_deactivate: AsyncMock,
        client: TestClient,
    ) -> None:
        mock_deactivate.return_value = 3
        response = client.post(
            "/api/v1/admin/tokens/deactivate",
            json={"tokens": ["tok-1", "tok-2", "tok-3"]},
        )
        assert response.status_code == 200
        data = response.json()
        assert data["deactivated_count"] == 3

    @patch(f"{ADMIN_SVC}.deactivate_failed_tokens", new_callable=AsyncMock)
    def test_deactivate_tokens_empty(
        self,
        mock_deactivate: AsyncMock,
        client: TestClient,
    ) -> None:
        mock_deactivate.return_value = 0
        response = client.post(
            "/api/v1/admin/tokens/deactivate",
            json={"tokens": []},
        )
        assert response.status_code == 200
        assert response.json()["deactivated_count"] == 0

    @patch(f"{ADMIN_SVC}.list_audit_logs", new_callable=AsyncMock)
    def test_audit_logs_endpoint(
        self,
        mock_list: AsyncMock,
        client: TestClient,
    ) -> None:
        log_id = uuid.UUID("00000000-0000-4000-8000-000000000701")
        mock_log = MagicMock()
        mock_log.id = log_id
        mock_log.actor_id = None
        mock_log.action = "cleanup"
        mock_log.resource_type = "all"
        mock_log.detail = {"retention_days": 90}
        mock_log.description = None
        mock_log.timestamp = "2026-02-28T12:00:00+00:00"
        mock_list.return_value = ([mock_log], 1)

        response = client.get(
            "/api/v1/admin/audit-logs",
            params={"page": 1, "limit": 50},
        )
        assert response.status_code == 200
        data = response.json()
        assert data["meta"]["total"] == 1
        assert len(data["data"]) == 1
        assert data["data"][0]["action"] == "cleanup"

    @patch(f"{ADMIN_SVC}.list_audit_logs", new_callable=AsyncMock)
    def test_audit_logs_endpoint_empty(
        self,
        mock_list: AsyncMock,
        client: TestClient,
    ) -> None:
        mock_list.return_value = ([], 0)
        response = client.get("/api/v1/admin/audit-logs")
        assert response.status_code == 200
        data = response.json()
        assert data["meta"]["total"] == 0
        assert data["data"] == []

    @patch(f"{ADMIN_SVC}.export_user_data", new_callable=AsyncMock)
    def test_export_endpoint(
        self,
        mock_export: AsyncMock,
        client: TestClient,
    ) -> None:
        user_id = uuid.UUID("00000000-0000-4000-8000-000000000801")
        mock_export.return_value = {"user": {"email": "test@example.com"}}
        response = client.get(f"/api/v1/admin/export/{user_id}")
        assert response.status_code == 200
        data = response.json()
        assert data["user"]["email"] == "test@example.com"
