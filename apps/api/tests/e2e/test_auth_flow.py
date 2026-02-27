"""E2E: Authentication flow — OAuth login, token refresh, protected endpoints."""

from unittest.mock import AsyncMock, patch

import pytest
from httpx import AsyncClient

from src.lib.auth import OAuthUserInfo

pytestmark = [
    pytest.mark.filterwarnings("ignore::jwt.warnings.InsecureKeyLengthWarning"),
]

MOCK_OAUTH_USER = OAuthUserInfo(
    id="google-e2e-001",
    email="e2e-user@test.com",
    name="E2E User",
    image=None,
    email_verified=True,
)


def _mock_verify_oauth() -> AsyncMock:
    return AsyncMock(return_value=MOCK_OAUTH_USER)


# ── Tests ──────────────────────────────────────────────────────────


class TestLoginFlow:
    @patch("src.auth.router.verify_oauth_token", new_callable=_mock_verify_oauth)
    async def test_login_creates_user(
        self, _mock: AsyncMock, client: AsyncClient
    ) -> None:
        """First login should create a user and return tokens."""
        resp = await client.post(
            "/api/v1/auth/login",
            json={"provider": "google", "access_token": "fake-token"},
        )
        assert resp.status_code == 200
        body = resp.json()
        assert "access_token" in body
        assert "refresh_token" in body
        assert body["token_type"] == "bearer"  # noqa: S105

    @patch("src.auth.router.verify_oauth_token", new_callable=_mock_verify_oauth)
    async def test_login_existing_user_no_duplicate(
        self, _mock: AsyncMock, client: AsyncClient
    ) -> None:
        """Re-login with same email returns existing user."""
        resp1 = await client.post(
            "/api/v1/auth/login",
            json={"provider": "google", "access_token": "fake-token"},
        )
        assert resp1.status_code == 200

        resp2 = await client.post(
            "/api/v1/auth/login",
            json={"provider": "google", "access_token": "fake-token"},
        )
        assert resp2.status_code == 200
        # Tokens may differ, but both should succeed without DB constraint errors

    @patch("src.auth.router.verify_oauth_token", new_callable=_mock_verify_oauth)
    async def test_refresh_token(self, _mock: AsyncMock, client: AsyncClient) -> None:
        """A valid refresh_token should yield a new access_token."""
        login_resp = await client.post(
            "/api/v1/auth/login",
            json={"provider": "google", "access_token": "fake-token"},
        )
        tokens = login_resp.json()

        refresh_resp = await client.post(
            "/api/v1/auth/refresh",
            json={"refresh_token": tokens["refresh_token"]},
        )
        assert refresh_resp.status_code == 200
        assert "access_token" in refresh_resp.json()

    @patch("src.auth.router.verify_oauth_token", new_callable=_mock_verify_oauth)
    async def test_refresh_with_access_token_rejected(
        self, _mock: AsyncMock, client: AsyncClient
    ) -> None:
        """Using an access_token as a refresh_token should be rejected."""
        login_resp = await client.post(
            "/api/v1/auth/login",
            json={"provider": "google", "access_token": "fake-token"},
        )
        tokens = login_resp.json()

        refresh_resp = await client.post(
            "/api/v1/auth/refresh",
            json={"refresh_token": tokens["access_token"]},
        )
        assert refresh_resp.status_code == 401


class TestProtectedEndpoint:
    @patch("src.auth.router.verify_oauth_token", new_callable=_mock_verify_oauth)
    async def test_authenticated_access(
        self, _mock: AsyncMock, client: AsyncClient
    ) -> None:
        """An authenticated user should be able to access protected endpoints."""
        login_resp = await client.post(
            "/api/v1/auth/login",
            json={"provider": "google", "access_token": "fake-token"},
        )
        token = login_resp.json()["access_token"]

        # Use /api/v1/relations as a protected endpoint (needs auth)
        resp = await client.get(
            "/api/v1/medications",
            params={"host_id": "00000000-0000-4000-8000-000000000001"},
            headers={"Authorization": f"Bearer {token}"},
        )
        # Should get 403 (no relation) not 401
        assert resp.status_code == 403

    async def test_unauthenticated_access_rejected(self, client: AsyncClient) -> None:
        """Request without a token should be rejected with 401."""
        resp = await client.get(
            "/api/v1/medications",
            params={"host_id": "00000000-0000-4000-8000-000000000001"},
        )
        assert resp.status_code == 401
