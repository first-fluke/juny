"""Tests for the users module (repository → service → router)."""

from __future__ import annotations

import uuid
from collections.abc import AsyncGenerator, Generator
from datetime import UTC, datetime
from typing import TYPE_CHECKING, Any
from unittest.mock import AsyncMock, MagicMock, patch

import pytest

from src.common.enums import UserRole
from src.lib.database import get_db
from src.main import app
from src.users.model import User
from src.users.schemas import UserRoleUpdate, UserUpdate
from src.users.service import (
    delete_own_account,
    delete_user,
    get_user,
    list_users,
    update_user,
    update_user_role,
)

if TYPE_CHECKING:
    from fastapi.testclient import TestClient

REPO = "src.users.repository"
SERVICE = "src.users.service"

MOCK_USER_ID = uuid.UUID("00000000-0000-4000-8000-000000000070")
TEST_USER_ID = "00000000-0000-4000-8000-000000000099"
TEST_ORG_ID = "00000000-0000-4000-8000-000000000095"
_NOW = datetime(2026, 1, 1, tzinfo=UTC)


def _mock_user(**overrides: Any) -> MagicMock:
    defaults: dict[str, Any] = {
        "id": MOCK_USER_ID,
        "email": "user@example.com",
        "image": None,
        "email_verified": True,
        "provider": "google",
        "provider_id": "google-001",
        "role": UserRole.HOST.value,
        "created_at": _NOW,
        "updated_at": _NOW,
    }
    defaults.update(overrides)
    # `name` is a MagicMock constructor kwarg, so set it via configure_mock
    mock_name = defaults.pop("name", "Test User")
    mock = MagicMock(spec=User, **defaults)
    mock.configure_mock(name=mock_name)
    return mock


# ---------------------------------------------------------------------------
# Service Tests
# ---------------------------------------------------------------------------


class TestUserService:
    @pytest.mark.asyncio
    @patch(f"{REPO}.find_by_id", new_callable=AsyncMock)
    async def test_get_user(self, mock_find: AsyncMock) -> None:
        mock_find.return_value = _mock_user()
        db = AsyncMock()
        result = await get_user(db, MOCK_USER_ID)
        assert result is mock_find.return_value

    @pytest.mark.asyncio
    @patch(f"{REPO}.save", new_callable=AsyncMock)
    async def test_update_user(self, mock_save: AsyncMock) -> None:
        user = _mock_user()
        mock_save.return_value = user
        db = AsyncMock()
        payload = UserUpdate(name="New Name", image="https://img.test/new.jpg")
        await update_user(db, user, payload)
        assert user.name == "New Name"
        assert user.image == "https://img.test/new.jpg"
        mock_save.assert_called_once_with(db, user)

    @pytest.mark.asyncio
    @patch(f"{REPO}.save", new_callable=AsyncMock)
    async def test_update_user_role_valid(self, mock_save: AsyncMock) -> None:
        user = _mock_user()
        mock_save.return_value = user
        db = AsyncMock()
        payload = UserRoleUpdate(role="organization")
        await update_user_role(db, user, payload)
        assert user.role == "organization"

    @pytest.mark.asyncio
    async def test_update_user_role_invalid(self) -> None:
        db = AsyncMock()
        user = _mock_user()
        payload = UserRoleUpdate(role="invalid_role")
        with pytest.raises(ValueError, match="Invalid role"):
            await update_user_role(db, user, payload)

    @pytest.mark.asyncio
    @patch(f"{REPO}.list_paginated", new_callable=AsyncMock)
    async def test_list_users(self, mock_list: AsyncMock) -> None:
        mock_list.return_value = ([_mock_user()], 1)
        db = AsyncMock()
        users, total = await list_users(db, limit=20, offset=0)
        assert total == 1
        assert len(users) == 1

    @pytest.mark.asyncio
    @patch(f"{REPO}.delete", new_callable=AsyncMock)
    async def test_delete_user(self, mock_delete: AsyncMock) -> None:
        db = AsyncMock()
        user = _mock_user()
        await delete_user(db, user)
        mock_delete.assert_called_once_with(db, user)

    @pytest.mark.asyncio
    @patch(f"{REPO}.delete", new_callable=AsyncMock)
    @patch(f"{REPO}.find_by_id", new_callable=AsyncMock)
    async def test_delete_own_account_with_image(
        self,
        mock_find: AsyncMock,
        mock_delete: AsyncMock,
    ) -> None:
        storage = AsyncMock()
        user = _mock_user(image="uploads/avatar.jpg")
        mock_find.return_value = user
        db = AsyncMock()
        await delete_own_account(db, MOCK_USER_ID, storage)
        storage.delete.assert_called_once_with("juny-uploads", "uploads/avatar.jpg")
        mock_delete.assert_called_once_with(db, user)

    @pytest.mark.asyncio
    @patch(f"{REPO}.delete", new_callable=AsyncMock)
    @patch(f"{REPO}.find_by_id", new_callable=AsyncMock)
    async def test_delete_own_account_no_image(
        self,
        mock_find: AsyncMock,
        mock_delete: AsyncMock,
    ) -> None:
        storage = AsyncMock()
        user = _mock_user(image=None)
        mock_find.return_value = user
        db = AsyncMock()
        await delete_own_account(db, MOCK_USER_ID, storage)
        storage.delete.assert_not_called()
        mock_delete.assert_called_once()

    @pytest.mark.asyncio
    @patch(f"{REPO}.delete", new_callable=AsyncMock)
    @patch(f"{REPO}.find_by_id", new_callable=AsyncMock)
    async def test_delete_own_account_storage_error_continues(
        self,
        mock_find: AsyncMock,
        mock_delete: AsyncMock,
    ) -> None:
        storage = AsyncMock()
        storage.delete.side_effect = Exception("storage down")
        user = _mock_user(image="avatar.jpg")
        mock_find.return_value = user
        db = AsyncMock()
        await delete_own_account(db, MOCK_USER_ID, storage)
        mock_delete.assert_called_once_with(db, user)

    @pytest.mark.asyncio
    async def test_delete_own_account_not_found(self) -> None:
        with patch(f"{REPO}.find_by_id", new_callable=AsyncMock, return_value=None):
            storage = AsyncMock()
            db = AsyncMock()
            with pytest.raises(ValueError, match="User not found"):
                await delete_own_account(db, MOCK_USER_ID, storage)


# ---------------------------------------------------------------------------
# Router Tests — Basic (unauthenticated)
# ---------------------------------------------------------------------------


class TestUserRouterBasic:
    def test_get_me_unauthenticated(self, client: TestClient) -> None:
        response = client.get("/api/v1/users/me")
        assert response.status_code == 401

    def test_list_users_unauthenticated(self, client: TestClient) -> None:
        response = client.get("/api/v1/users")
        assert response.status_code == 401


# ---------------------------------------------------------------------------
# Router Tests — Extended (mocked DB)
# ---------------------------------------------------------------------------


class TestUserRouterExtended:
    @pytest.fixture(autouse=True)
    def _override_db(self) -> Generator[None, None, None]:
        async def _db_override() -> AsyncGenerator[AsyncMock, None]:
            yield AsyncMock()

        app.dependency_overrides[get_db] = _db_override
        yield
        app.dependency_overrides.clear()

    @patch(f"{SERVICE}.get_user", new_callable=AsyncMock)
    def test_get_me_200(
        self,
        mock_get: AsyncMock,
        authed_client: TestClient,
    ) -> None:
        mock_get.return_value = _mock_user(id=uuid.UUID(TEST_USER_ID))
        response = authed_client.get("/api/v1/users/me")
        assert response.status_code == 200
        assert response.json()["email"] == "user@example.com"

    @patch(f"{SERVICE}.update_user", new_callable=AsyncMock)
    @patch(f"{SERVICE}.get_user", new_callable=AsyncMock)
    def test_patch_me_200(
        self,
        mock_get: AsyncMock,
        mock_update: AsyncMock,
        authed_client: TestClient,
    ) -> None:
        user = _mock_user(id=uuid.UUID(TEST_USER_ID), name="Updated")
        mock_get.return_value = user
        mock_update.return_value = user
        response = authed_client.patch("/api/v1/users/me", json={"name": "Updated"})
        assert response.status_code == 200

    @patch(f"{SERVICE}.get_user", new_callable=AsyncMock)
    def test_get_user_self_200(
        self,
        mock_get: AsyncMock,
        authed_client: TestClient,
    ) -> None:
        mock_get.return_value = _mock_user(id=uuid.UUID(TEST_USER_ID))
        response = authed_client.get(f"/api/v1/users/{TEST_USER_ID}")
        assert response.status_code == 200

    @patch("src.users.router.authorize_host_access", new_callable=AsyncMock)
    @patch(f"{SERVICE}.get_user", new_callable=AsyncMock)
    def test_get_user_via_relation_200(
        self,
        mock_get: AsyncMock,
        mock_auth: AsyncMock,
        authed_client: TestClient,
    ) -> None:
        other_id = "00000000-0000-4000-8000-000000000071"
        mock_get.return_value = _mock_user(id=uuid.UUID(other_id))
        response = authed_client.get(f"/api/v1/users/{other_id}")
        assert response.status_code == 200
        mock_auth.assert_called_once()

    def test_list_users_non_org_403(self, authed_client: TestClient) -> None:
        response = authed_client.get("/api/v1/users")
        assert response.status_code == 403

    @patch(f"{SERVICE}.list_users", new_callable=AsyncMock)
    def test_list_users_org_200(
        self,
        mock_list: AsyncMock,
        organization_client: TestClient,
    ) -> None:
        mock_list.return_value = ([_mock_user()], 1)
        response = organization_client.get("/api/v1/users")
        assert response.status_code == 200
        data = response.json()
        assert data["meta"]["total"] == 1

    @patch(f"{SERVICE}.update_user_role", new_callable=AsyncMock)
    @patch(f"{SERVICE}.get_user", new_callable=AsyncMock)
    def test_update_role_org_200(
        self,
        mock_get: AsyncMock,
        mock_update: AsyncMock,
        organization_client: TestClient,
    ) -> None:
        user = _mock_user(role="concierge")
        mock_get.return_value = user
        mock_update.return_value = user
        response = organization_client.patch(
            f"/api/v1/users/{MOCK_USER_ID}/role",
            json={"role": "concierge"},
        )
        assert response.status_code == 200

    def test_update_role_non_org_403(self, authed_client: TestClient) -> None:
        response = authed_client.patch(
            f"/api/v1/users/{MOCK_USER_ID}/role",
            json={"role": "concierge"},
        )
        assert response.status_code == 403

    @patch(f"{SERVICE}.delete_user", new_callable=AsyncMock)
    @patch(f"{SERVICE}.get_user", new_callable=AsyncMock)
    def test_delete_user_org_204(
        self,
        mock_get: AsyncMock,
        mock_delete: AsyncMock,
        organization_client: TestClient,
    ) -> None:
        mock_get.return_value = _mock_user()
        response = organization_client.delete(f"/api/v1/users/{MOCK_USER_ID}")
        assert response.status_code == 204

    def test_delete_user_non_org_403(self, authed_client: TestClient) -> None:
        response = authed_client.delete(f"/api/v1/users/{MOCK_USER_ID}")
        assert response.status_code == 403

    @patch(f"{SERVICE}.delete_own_account", new_callable=AsyncMock)
    def test_delete_me_204(
        self,
        mock_delete: AsyncMock,
        authed_client: TestClient,
    ) -> None:
        response = authed_client.delete("/api/v1/users/me")
        assert response.status_code == 204
        mock_delete.assert_called_once()

    def test_delete_me_unauthenticated(self, client: TestClient) -> None:
        response = client.delete("/api/v1/users/me")
        assert response.status_code == 401

    @patch("src.admin.service.export_user_data", new_callable=AsyncMock)
    def test_export_me_200(
        self,
        mock_export: AsyncMock,
        authed_client: TestClient,
    ) -> None:
        mock_export.return_value = {"user": {"email": "me@example.com"}}
        response = authed_client.get("/api/v1/users/me/export")
        assert response.status_code == 200
        assert response.json()["user"]["email"] == "me@example.com"

    def test_export_me_unauthenticated(self, client: TestClient) -> None:
        response = client.get("/api/v1/users/me/export")
        assert response.status_code == 401
