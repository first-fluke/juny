"""E2E: WellnessLog — create, list (pagination), get, authorization."""

import pytest
from httpx import AsyncClient

from src.users.model import User

pytestmark = [
    pytest.mark.filterwarnings("ignore::jwt.warnings.InsecureKeyLengthWarning"),
]


class TestWellnessLogCRUD:
    async def test_create_wellness_log(
        self, host_client: AsyncClient, seed_host: User
    ) -> None:
        resp = await host_client.post(
            "/api/v1/wellness",
            json={
                "host_id": str(seed_host.id),
                "status": "normal",
                "summary": "Feeling good today",
                "details": {"temperature": 36.5},
            },
        )
        assert resp.status_code == 201
        body = resp.json()
        assert body["status"] == "normal"
        assert body["summary"] == "Feeling good today"
        assert body["details"]["temperature"] == 36.5

    async def test_create_emergency_log(
        self, host_client: AsyncClient, seed_host: User
    ) -> None:
        resp = await host_client.post(
            "/api/v1/wellness",
            json={
                "host_id": str(seed_host.id),
                "status": "emergency",
                "summary": "Fall detected",
                "details": {"location": "bathroom"},
            },
        )
        assert resp.status_code == 201
        assert resp.json()["status"] == "emergency"

    async def test_list_wellness_logs_pagination(
        self, host_client: AsyncClient, seed_host: User
    ) -> None:
        host_id = str(seed_host.id)
        for i in range(3):
            await host_client.post(
                "/api/v1/wellness",
                json={
                    "host_id": host_id,
                    "status": "normal",
                    "summary": f"Log entry {i}",
                },
            )

        resp = await host_client.get(
            "/api/v1/wellness",
            params={"host_id": host_id, "limit": 2},
        )
        assert resp.status_code == 200
        body = resp.json()
        assert len(body["data"]) == 2
        assert body["meta"]["total"] == 3

    async def test_get_wellness_log(
        self, host_client: AsyncClient, seed_host: User
    ) -> None:
        create_resp = await host_client.post(
            "/api/v1/wellness",
            json={
                "host_id": str(seed_host.id),
                "status": "warning",
                "summary": "Elevated heart rate",
            },
        )
        log_id = create_resp.json()["id"]

        resp = await host_client.get(f"/api/v1/wellness/{log_id}")
        assert resp.status_code == 200
        assert resp.json()["summary"] == "Elevated heart rate"


class TestWellnessLogAuthorization:
    async def test_create_unauthorized(
        self, unrelated_client: AsyncClient, seed_host: User
    ) -> None:
        """A user with no relation to the host should get 403."""
        resp = await unrelated_client.post(
            "/api/v1/wellness",
            json={
                "host_id": str(seed_host.id),
                "status": "normal",
                "summary": "Should be blocked",
            },
        )
        assert resp.status_code == 403
