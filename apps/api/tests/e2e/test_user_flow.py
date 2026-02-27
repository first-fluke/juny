"""E2E tests for user endpoints."""

from __future__ import annotations

from typing import TYPE_CHECKING

import pytest

from src.users.model import User

if TYPE_CHECKING:
    from httpx import AsyncClient

pytestmark = pytest.mark.asyncio


class TestUserProfile:
    async def test_get_me(self, host_client: AsyncClient) -> None:
        response = await host_client.get("/api/v1/users/me")
        assert response.status_code == 200
        data = response.json()
        assert data["email"] == "host@test.com"
        assert data["role"] == "host"

    async def test_patch_me(self, host_client: AsyncClient) -> None:
        response = await host_client.patch(
            "/api/v1/users/me",
            json={"name": "Updated Host"},
        )
        assert response.status_code == 200
        assert response.json()["name"] == "Updated Host"

    async def test_get_self_by_id(
        self, host_client: AsyncClient, seed_host: User
    ) -> None:
        response = await host_client.get(f"/api/v1/users/{seed_host.id}")
        assert response.status_code == 200
        assert response.json()["id"] == str(seed_host.id)


class TestUserAuthorization:
    async def test_list_users_non_org_403(self, host_client: AsyncClient) -> None:
        response = await host_client.get("/api/v1/users")
        assert response.status_code == 403

    async def test_delete_user_non_org_403(
        self, host_client: AsyncClient, seed_host: User
    ) -> None:
        target_id = "00000000-0000-4000-8000-000000000e02"
        response = await host_client.delete(f"/api/v1/users/{target_id}")
        assert response.status_code == 403


class TestUserAdmin:
    async def test_list_users_org_200(
        self, organization_client: AsyncClient, seed_host: User
    ) -> None:
        response = await organization_client.get("/api/v1/users")
        assert response.status_code == 200
        data = response.json()
        assert data["meta"]["total"] >= 1

    async def test_update_role_org_200(
        self, organization_client: AsyncClient, seed_host: User
    ) -> None:
        response = await organization_client.patch(
            f"/api/v1/users/{seed_host.id}/role",
            json={"role": "concierge"},
        )
        assert response.status_code == 200
        assert response.json()["role"] == "concierge"

    async def test_delete_user_org_204(
        self,
        organization_client: AsyncClient,
        seed_host: User,
        seed_caregiver: User,
    ) -> None:
        # Delete the caregiver (not the host, to avoid FK issues)
        response = await organization_client.delete(
            f"/api/v1/users/{seed_caregiver.id}"
        )
        assert response.status_code == 204

        # Verify gone
        response = await organization_client.get(f"/api/v1/users/{seed_caregiver.id}")
        assert response.status_code == 404
