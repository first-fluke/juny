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
    @patch(f"{ADMIN_REPO}.delete_old_wellness_logs", new_callable=AsyncMock)
    @patch(f"{ADMIN_REPO}.deactivate_old_tokens", new_callable=AsyncMock)
    async def test_cleanup_all(
        self,
        mock_deactivate: AsyncMock,
        mock_delete_logs: AsyncMock,
    ) -> None:
        from src.admin.service import cleanup_data

        mock_delete_logs.return_value = 5
        mock_deactivate.return_value = 2
        db = AsyncMock()

        result = await cleanup_data(db, retention_days=90, resource_type="all")

        assert result.deleted_wellness_logs == 5
        assert result.deactivated_tokens == 2
        mock_delete_logs.assert_called_once()
        mock_deactivate.assert_called_once()
        db.commit.assert_called_once()

    @pytest.mark.asyncio
    @patch(f"{ADMIN_REPO}.delete_old_wellness_logs", new_callable=AsyncMock)
    @patch(f"{ADMIN_REPO}.deactivate_old_tokens", new_callable=AsyncMock)
    async def test_cleanup_wellness_logs_only(
        self,
        mock_deactivate: AsyncMock,
        mock_delete_logs: AsyncMock,
    ) -> None:
        from src.admin.service import cleanup_data

        mock_delete_logs.return_value = 3
        db = AsyncMock()

        result = await cleanup_data(
            db, retention_days=90, resource_type="wellness_logs"
        )

        assert result.deleted_wellness_logs == 3
        assert result.deactivated_tokens == 0
        mock_delete_logs.assert_called_once()
        mock_deactivate.assert_not_called()

    @pytest.mark.asyncio
    @patch(f"{ADMIN_REPO}.delete_old_wellness_logs", new_callable=AsyncMock)
    @patch(f"{ADMIN_REPO}.deactivate_old_tokens", new_callable=AsyncMock)
    async def test_cleanup_device_tokens_only(
        self,
        mock_deactivate: AsyncMock,
        mock_delete_logs: AsyncMock,
    ) -> None:
        from src.admin.service import cleanup_data

        mock_deactivate.return_value = 4
        db = AsyncMock()

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
