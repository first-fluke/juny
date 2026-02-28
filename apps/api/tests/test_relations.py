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
from src.relations.model import CareRelation
from src.relations.schemas import (
    CAREGIVER_ROLES,
    CareRelationCreate,
    CareRelationUpdate,
)
from src.relations.service import (
    create_relation,
    delete_relation,
    get_relation,
    list_relations_for_caregiver,
    list_relations_for_host,
    update_relation,
)

if TYPE_CHECKING:
    from fastapi.testclient import TestClient

REPO = "src.relations.repository"
SERVICE = "src.relations.service"

MOCK_REL_ID = uuid.UUID("00000000-0000-4000-8000-000000000040")
MOCK_HOST_ID = uuid.UUID("00000000-0000-4000-8000-000000000041")
MOCK_CAREGIVER_ID = uuid.UUID("00000000-0000-4000-8000-000000000042")

TEST_USER_ID = "00000000-0000-4000-8000-000000000099"
TEST_CAREGIVER_ID = "00000000-0000-4000-8000-000000000098"

_NOW = datetime(2026, 1, 1, tzinfo=UTC)


def _mock_relation(**overrides: Any) -> MagicMock:
    defaults: dict[str, Any] = {
        "id": MOCK_REL_ID,
        "host_id": MOCK_HOST_ID,
        "caregiver_id": MOCK_CAREGIVER_ID,
        "role": "concierge",
        "is_active": True,
        "created_at": _NOW,
        "updated_at": None,
    }
    defaults.update(overrides)
    return MagicMock(spec=CareRelation, **defaults)


# ---------------------------------------------------------------------------
# Service Tests
# ---------------------------------------------------------------------------


class TestRelationService:
    @pytest.mark.asyncio
    @patch(f"{REPO}.create", new_callable=AsyncMock)
    async def test_create_relation_success(self, mock_create: AsyncMock) -> None:
        mock_create.return_value = _mock_relation()
        db = AsyncMock()
        payload = CareRelationCreate(
            host_id=uuid.UUID("00000000-0000-4000-8000-000000000043"),
            caregiver_id=uuid.UUID("00000000-0000-4000-8000-000000000044"),
            role="concierge",
        )
        result = await create_relation(db, payload)
        mock_create.assert_called_once()
        assert result is mock_create.return_value

    @pytest.mark.asyncio
    async def test_create_relation_invalid_role(self) -> None:
        db = AsyncMock()
        payload = CareRelationCreate(
            host_id=uuid.UUID("00000000-0000-4000-8000-000000000045"),
            caregiver_id=uuid.UUID("00000000-0000-4000-8000-000000000046"),
            role="host",
        )
        with pytest.raises(ValueError, match="Invalid caregiver role"):
            await create_relation(db, payload)

    @pytest.mark.asyncio
    async def test_create_relation_self_relation(self) -> None:
        db = AsyncMock()
        same_id = uuid.UUID("00000000-0000-4000-8000-000000000047")
        payload = CareRelationCreate(
            host_id=same_id,
            caregiver_id=same_id,
            role="concierge",
        )
        with pytest.raises(ValueError, match="must differ"):
            await create_relation(db, payload)

    @pytest.mark.asyncio
    @patch(f"{REPO}.save", new_callable=AsyncMock)
    async def test_update_relation_role(self, mock_save: AsyncMock) -> None:
        relation = _mock_relation()
        mock_save.return_value = relation
        db = AsyncMock()
        payload = CareRelationUpdate(role="care_worker")
        await update_relation(db, relation, payload)
        assert relation.role == "care_worker"
        mock_save.assert_called_once_with(db, relation)

    @pytest.mark.asyncio
    async def test_update_relation_invalid_role(self) -> None:
        db = AsyncMock()
        relation = _mock_relation()
        payload = CareRelationUpdate(role="host")
        with pytest.raises(ValueError, match="Invalid caregiver role"):
            await update_relation(db, relation, payload)

    @pytest.mark.asyncio
    @patch(f"{REPO}.save", new_callable=AsyncMock)
    async def test_update_relation_deactivate(self, mock_save: AsyncMock) -> None:
        relation = _mock_relation()
        mock_save.return_value = relation
        db = AsyncMock()
        payload = CareRelationUpdate(is_active=False)
        await update_relation(db, relation, payload)
        assert relation.is_active is False
        mock_save.assert_called_once()

    @pytest.mark.asyncio
    @patch(f"{REPO}.delete", new_callable=AsyncMock)
    async def test_delete_relation(self, mock_delete: AsyncMock) -> None:
        db = AsyncMock()
        relation = _mock_relation()
        await delete_relation(db, relation)
        mock_delete.assert_called_once_with(db, relation)

    def test_caregiver_roles(self) -> None:
        assert "concierge" in CAREGIVER_ROLES
        assert "care_worker" in CAREGIVER_ROLES
        assert "organization" in CAREGIVER_ROLES
        assert "host" not in CAREGIVER_ROLES

    @pytest.mark.asyncio
    @patch(f"{REPO}.find_by_host", new_callable=AsyncMock)
    async def test_list_relations_for_host(self, mock_find: AsyncMock) -> None:
        relations = [_mock_relation(), _mock_relation()]
        mock_find.return_value = (relations, 2)
        db = AsyncMock()
        result = await list_relations_for_host(db, MOCK_HOST_ID)
        assert result == (relations, 2)
        mock_find.assert_called_once_with(
            db, MOCK_HOST_ID, active_only=True, limit=20, offset=0
        )

    @pytest.mark.asyncio
    @patch(f"{REPO}.find_by_caregiver", new_callable=AsyncMock)
    async def test_list_relations_for_caregiver(self, mock_find: AsyncMock) -> None:
        relations = [_mock_relation()]
        mock_find.return_value = (relations, 1)
        db = AsyncMock()
        result = await list_relations_for_caregiver(db, MOCK_CAREGIVER_ID)
        assert result == (relations, 1)
        mock_find.assert_called_once_with(
            db, MOCK_CAREGIVER_ID, active_only=True, limit=20, offset=0
        )

    @pytest.mark.asyncio
    @patch(f"{REPO}.find_by_id", new_callable=AsyncMock)
    async def test_get_relation_found(self, mock_find: AsyncMock) -> None:
        rel = _mock_relation()
        mock_find.return_value = rel
        db = AsyncMock()
        result = await get_relation(db, MOCK_REL_ID)
        assert result is rel

    @pytest.mark.asyncio
    @patch(f"{REPO}.find_by_id", new_callable=AsyncMock)
    async def test_get_relation_not_found(self, mock_find: AsyncMock) -> None:
        mock_find.return_value = None
        db = AsyncMock()
        result = await get_relation(db, MOCK_REL_ID)
        assert result is None


# ---------------------------------------------------------------------------
# Router Tests
# ---------------------------------------------------------------------------


class TestRelationRouter:
    def test_create_relation_unauthenticated(self, client: TestClient) -> None:
        response = client.post(
            "/api/v1/relations",
            json={
                "host_id": "00000000-0000-4000-8000-000000000048",
                "caregiver_id": "00000000-0000-4000-8000-000000000049",
                "role": "concierge",
            },
        )
        assert response.status_code == 401

    def test_list_relations_requires_filter(self, authed_client: TestClient) -> None:
        response = authed_client.get("/api/v1/relations")
        assert response.status_code == 400
        assert "host_id or caregiver_id" in response.json()["detail"]


class TestRelationRouterExtended:
    """Extended router tests with mocked DB and services."""

    @pytest.fixture(autouse=True)
    def _override_db(self) -> Generator[None, None, None]:
        async def _db_override() -> AsyncGenerator[AsyncMock, None]:
            yield AsyncMock()

        app.dependency_overrides[get_db] = _db_override
        yield
        app.dependency_overrides.clear()

    @patch(f"{SERVICE}.create_relation", new_callable=AsyncMock)
    def test_create_201(
        self,
        mock_create: AsyncMock,
        authed_client: TestClient,
    ) -> None:
        mock_create.return_value = _mock_relation(
            host_id=uuid.UUID(TEST_USER_ID),
            caregiver_id=MOCK_CAREGIVER_ID,
        )
        response = authed_client.post(
            "/api/v1/relations",
            json={
                "host_id": TEST_USER_ID,
                "caregiver_id": str(MOCK_CAREGIVER_ID),
                "role": "concierge",
            },
        )
        assert response.status_code == 201
        data = response.json()
        assert data["role"] == "concierge"

    def test_create_403_not_participant(self, authed_client: TestClient) -> None:
        response = authed_client.post(
            "/api/v1/relations",
            json={
                "host_id": "00000000-0000-4000-8000-000000000060",
                "caregiver_id": "00000000-0000-4000-8000-000000000061",
                "role": "concierge",
            },
        )
        assert response.status_code == 403

    @patch(f"{SERVICE}.list_relations_for_host", new_callable=AsyncMock)
    def test_list_by_host(
        self,
        mock_list: AsyncMock,
        authed_client: TestClient,
    ) -> None:
        mock_list.return_value = (
            [_mock_relation(host_id=uuid.UUID(TEST_USER_ID))],
            1,
        )
        response = authed_client.get(
            "/api/v1/relations",
            params={"host_id": TEST_USER_ID},
        )
        assert response.status_code == 200
        data = response.json()
        assert len(data["data"]) == 1
        assert data["meta"]["total"] == 1
        assert data["meta"]["page"] == 1

    @patch(f"{SERVICE}.list_relations_for_caregiver", new_callable=AsyncMock)
    def test_list_by_caregiver(
        self,
        mock_list: AsyncMock,
        caregiver_client: TestClient,
    ) -> None:
        mock_list.return_value = (
            [_mock_relation(caregiver_id=uuid.UUID(TEST_CAREGIVER_ID))],
            1,
        )
        response = caregiver_client.get(
            "/api/v1/relations",
            params={"caregiver_id": TEST_CAREGIVER_ID},
        )
        assert response.status_code == 200
        data = response.json()
        assert len(data["data"]) == 1
        assert data["meta"]["total"] == 1

    @patch(
        "src.relations.router.authorize_host_access",
        new_callable=AsyncMock,
        side_effect=HTTPException(status_code=403, detail="Forbidden"),
    )
    def test_list_unauthorized_403(
        self,
        mock_auth: AsyncMock,
        authed_client: TestClient,
    ) -> None:
        other_host = "00000000-0000-4000-8000-000000000055"
        response = authed_client.get(
            "/api/v1/relations",
            params={"host_id": other_host},
        )
        assert response.status_code == 403

    @patch("src.relations.router.authorize_relation_access", new_callable=AsyncMock)
    @patch(f"{SERVICE}.get_relation", new_callable=AsyncMock)
    def test_get_200(
        self,
        mock_get: AsyncMock,
        mock_auth: AsyncMock,
        authed_client: TestClient,
    ) -> None:
        mock_get.return_value = _mock_relation(host_id=uuid.UUID(TEST_USER_ID))
        response = authed_client.get(f"/api/v1/relations/{MOCK_REL_ID}")
        assert response.status_code == 200
        assert response.json()["id"] == str(MOCK_REL_ID)

    @patch(f"{SERVICE}.get_relation", new_callable=AsyncMock)
    def test_get_404(
        self,
        mock_get: AsyncMock,
        authed_client: TestClient,
    ) -> None:
        mock_get.return_value = None
        fake_id = "00000000-0000-4000-8000-000000000060"
        response = authed_client.get(f"/api/v1/relations/{fake_id}")
        assert response.status_code == 404

    @patch(f"{SERVICE}.delete_relation", new_callable=AsyncMock)
    @patch("src.relations.router.authorize_relation_access", new_callable=AsyncMock)
    @patch(f"{SERVICE}.get_relation", new_callable=AsyncMock)
    def test_delete_204(
        self,
        mock_get: AsyncMock,
        mock_auth: AsyncMock,
        mock_delete: AsyncMock,
        authed_client: TestClient,
    ) -> None:
        mock_get.return_value = _mock_relation(host_id=uuid.UUID(TEST_USER_ID))
        response = authed_client.delete(f"/api/v1/relations/{MOCK_REL_ID}")
        assert response.status_code == 204
