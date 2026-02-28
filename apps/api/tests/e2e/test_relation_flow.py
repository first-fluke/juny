"""E2E: CareRelation CRUD — create, list, update, delete, constraints."""

import pytest
from httpx import AsyncClient

from src.users.model import User
from tests.e2e.conftest import CAREGIVER_USER_ID, HOST_USER_ID

pytestmark = [
    pytest.mark.filterwarnings("ignore::jwt.warnings.InsecureKeyLengthWarning"),
]


class TestRelationCRUD:
    async def test_create_relation(
        self,
        host_client: AsyncClient,
        seed_host: User,
        seed_caregiver: User,
    ) -> None:
        resp = await host_client.post(
            "/api/v1/relations",
            json={
                "host_id": str(HOST_USER_ID),
                "caregiver_id": str(CAREGIVER_USER_ID),
                "role": "concierge",
            },
        )
        assert resp.status_code == 201
        body = resp.json()
        assert body["host_id"] == str(HOST_USER_ID)
        assert body["caregiver_id"] == str(CAREGIVER_USER_ID)
        assert body["role"] == "concierge"
        assert body["is_active"] is True

    async def test_list_relations_by_host(
        self,
        host_client: AsyncClient,
        seed_host: User,
        seed_caregiver: User,
    ) -> None:
        # Create a relation first
        await host_client.post(
            "/api/v1/relations",
            json={
                "host_id": str(HOST_USER_ID),
                "caregiver_id": str(CAREGIVER_USER_ID),
                "role": "concierge",
            },
        )

        resp = await host_client.get(
            "/api/v1/relations",
            params={"host_id": str(HOST_USER_ID)},
        )
        assert resp.status_code == 200
        body = resp.json()
        assert "data" in body
        assert "meta" in body
        assert len(body["data"]) >= 1
        assert body["data"][0]["host_id"] == str(HOST_USER_ID)
        assert body["meta"]["total"] >= 1

    async def test_list_relations_by_caregiver(
        self,
        caregiver_client: AsyncClient,
        seed_host: User,
        seed_caregiver: User,
        db_session,
    ) -> None:
        """Caregiver can list their own relations."""
        from src.relations.model import CareRelation

        # Seed relation via DB directly (caregiver_client doesn't own the host)
        relation = CareRelation(
            host_id=HOST_USER_ID,
            caregiver_id=CAREGIVER_USER_ID,
            role="concierge",
        )
        db_session.add(relation)
        await db_session.commit()

        resp = await caregiver_client.get(
            "/api/v1/relations",
            params={"caregiver_id": str(CAREGIVER_USER_ID)},
        )
        assert resp.status_code == 200
        body = resp.json()
        assert "data" in body
        assert "meta" in body
        assert len(body["data"]) >= 1
        assert body["data"][0]["caregiver_id"] == str(CAREGIVER_USER_ID)
        assert body["meta"]["total"] >= 1

    async def test_update_relation_deactivate(
        self,
        host_client: AsyncClient,
        seed_host: User,
        seed_caregiver: User,
    ) -> None:
        create_resp = await host_client.post(
            "/api/v1/relations",
            json={
                "host_id": str(HOST_USER_ID),
                "caregiver_id": str(CAREGIVER_USER_ID),
                "role": "concierge",
            },
        )
        relation_id = create_resp.json()["id"]

        resp = await host_client.patch(
            f"/api/v1/relations/{relation_id}",
            json={"is_active": False},
        )
        assert resp.status_code == 200
        assert resp.json()["is_active"] is False

    async def test_delete_relation(
        self,
        host_client: AsyncClient,
        seed_host: User,
        seed_caregiver: User,
    ) -> None:
        create_resp = await host_client.post(
            "/api/v1/relations",
            json={
                "host_id": str(HOST_USER_ID),
                "caregiver_id": str(CAREGIVER_USER_ID),
                "role": "concierge",
            },
        )
        relation_id = create_resp.json()["id"]

        del_resp = await host_client.delete(
            f"/api/v1/relations/{relation_id}",
        )
        assert del_resp.status_code == 204


class TestRelationConstraints:
    async def test_self_relation_rejected(
        self,
        host_client: AsyncClient,
        seed_host: User,
    ) -> None:
        """host_id == caregiver_id should be rejected with 422."""
        resp = await host_client.post(
            "/api/v1/relations",
            json={
                "host_id": str(HOST_USER_ID),
                "caregiver_id": str(HOST_USER_ID),
                "role": "concierge",
            },
        )
        assert resp.status_code == 422

    async def test_invalid_role_rejected(
        self,
        host_client: AsyncClient,
        seed_host: User,
        seed_caregiver: User,
    ) -> None:
        """role='host' is not a valid caregiver role → 422."""
        resp = await host_client.post(
            "/api/v1/relations",
            json={
                "host_id": str(HOST_USER_ID),
                "caregiver_id": str(CAREGIVER_USER_ID),
                "role": "host",
            },
        )
        assert resp.status_code == 422
