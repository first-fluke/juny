"""E2E tests for device token (notification) endpoints."""

from __future__ import annotations

from typing import TYPE_CHECKING

import pytest

from tests.e2e.conftest import CAREGIVER_USER_ID, HOST_USER_ID, _create_token

if TYPE_CHECKING:
    from httpx import AsyncClient

pytestmark = pytest.mark.asyncio


class TestDeviceTokenRegistration:
    async def test_register_device_token(self, host_client: AsyncClient) -> None:
        response = await host_client.post(
            "/api/v1/notifications/device-tokens",
            json={"token": "fcm-token-e2e-001", "platform": "ios"},
        )
        assert response.status_code == 201
        data = response.json()
        assert data["token"] == "fcm-token-e2e-001"  # noqa: S105
        assert data["platform"] == "ios"
        assert data["is_active"] is True

    async def test_register_duplicate_token_reactivates(
        self, host_client: AsyncClient
    ) -> None:
        # Register first time
        await host_client.post(
            "/api/v1/notifications/device-tokens",
            json={"token": "fcm-token-dup", "platform": "android"},
        )
        # Register again — should succeed (upsert/reactivate)
        response = await host_client.post(
            "/api/v1/notifications/device-tokens",
            json={"token": "fcm-token-dup", "platform": "android"},
        )
        assert response.status_code == 201
        assert response.json()["is_active"] is True


class TestDeviceTokenList:
    async def test_list_device_tokens(self, host_client: AsyncClient) -> None:
        # Register two tokens
        await host_client.post(
            "/api/v1/notifications/device-tokens",
            json={"token": "fcm-list-001", "platform": "ios"},
        )
        await host_client.post(
            "/api/v1/notifications/device-tokens",
            json={"token": "fcm-list-002", "platform": "android"},
        )

        response = await host_client.get("/api/v1/notifications/device-tokens")
        assert response.status_code == 200
        data = response.json()
        assert len(data) == 2
        tokens = {item["token"] for item in data}
        assert tokens == {"fcm-list-001", "fcm-list-002"}

    async def test_list_empty(self, host_client: AsyncClient) -> None:
        response = await host_client.get("/api/v1/notifications/device-tokens")
        assert response.status_code == 200
        assert response.json() == []


class TestDeviceTokenDeletion:
    async def test_delete_device_token(self, host_client: AsyncClient) -> None:
        # Register
        reg_resp = await host_client.post(
            "/api/v1/notifications/device-tokens",
            json={"token": "fcm-del-001", "platform": "web"},
        )
        token_id = reg_resp.json()["id"]

        # Delete
        del_resp = await host_client.delete(
            f"/api/v1/notifications/device-tokens/{token_id}"
        )
        assert del_resp.status_code == 204

        # Verify removed from list
        list_resp = await host_client.get("/api/v1/notifications/device-tokens")
        assert list_resp.status_code == 200
        assert list_resp.json() == []

    async def test_delete_nonexistent_404(self, host_client: AsyncClient) -> None:
        response = await host_client.delete(
            "/api/v1/notifications/device-tokens/00000000-0000-4000-8000-ffffffffffff"
        )
        assert response.status_code == 404

    async def test_delete_other_users_token_404(
        self,
        client: AsyncClient,
        seed_host: object,
        seed_caregiver: object,
    ) -> None:
        host_headers = {
            "Authorization": f"Bearer {_create_token(str(HOST_USER_ID), 'host')}"
        }
        cg_token = _create_token(str(CAREGIVER_USER_ID), "concierge")
        cg_headers = {"Authorization": f"Bearer {cg_token}"}

        # Host registers a token
        reg_resp = await client.post(
            "/api/v1/notifications/device-tokens",
            json={"token": "fcm-cross-001", "platform": "ios"},
            headers=host_headers,
        )
        token_id = reg_resp.json()["id"]

        # Caregiver tries to delete it
        del_resp = await client.delete(
            f"/api/v1/notifications/device-tokens/{token_id}",
            headers=cg_headers,
        )
        assert del_resp.status_code == 404


class TestDeviceTokenUnauthenticated:
    async def test_register_unauthenticated(self, client: AsyncClient) -> None:
        response = await client.post(
            "/api/v1/notifications/device-tokens",
            json={"token": "unauth-token", "platform": "ios"},
        )
        assert response.status_code == 401

    async def test_list_unauthenticated(self, client: AsyncClient) -> None:
        response = await client.get("/api/v1/notifications/device-tokens")
        assert response.status_code == 401

    async def test_delete_unauthenticated(self, client: AsyncClient) -> None:
        response = await client.delete(
            "/api/v1/notifications/device-tokens/00000000-0000-4000-8000-000000000001"
        )
        assert response.status_code == 401
