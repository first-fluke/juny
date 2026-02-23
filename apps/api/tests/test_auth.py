from __future__ import annotations

import uuid
from collections.abc import AsyncGenerator, Generator
from typing import TYPE_CHECKING, Any
from unittest.mock import AsyncMock, MagicMock, patch

import pytest

from src.auth.repository import create_user, find_by_email, find_by_id
from src.auth.service import get_user_by_id, issue_tokens, login_or_create_user
from src.lib.auth import (
    OAuthUserInfo,
    create_access_token,
    create_refresh_token,
)
from src.lib.database import get_db
from src.main import app
from src.users.model import User

if TYPE_CHECKING:
    from fastapi.testclient import TestClient

REPO = "src.auth.repository"
SERVICE = "src.auth.service"
VERIFY_OAUTH = "src.auth.router.verify_oauth_token"

MOCK_USER_ID = uuid.UUID("00000000-0000-4000-8000-000000000010")
MOCK_EMAIL = "test@example.com"


def _mock_user(**overrides: Any) -> MagicMock:
    defaults: dict[str, Any] = {
        "id": MOCK_USER_ID,
        "email": MOCK_EMAIL,
        "name": "Test User",
        "image": None,
        "email_verified": True,
        "provider": "google",
        "provider_id": "google-123",
        "role": "host",
    }
    defaults.update(overrides)
    return MagicMock(spec=User, **defaults)


# ---------------------------------------------------------------------------
# Repository Tests
# ---------------------------------------------------------------------------


class TestAuthRepository:
    """Tests for src.auth.repository functions."""

    @pytest.mark.asyncio
    async def test_find_by_email_found(self, mock_db: AsyncMock) -> None:
        user = _mock_user()
        mock_result = MagicMock()
        mock_result.scalar_one_or_none.return_value = user
        mock_db.execute.return_value = mock_result

        result = await find_by_email(mock_db, MOCK_EMAIL)
        assert result is user
        mock_db.execute.assert_called_once()

    @pytest.mark.asyncio
    async def test_find_by_email_not_found(self, mock_db: AsyncMock) -> None:
        mock_result = MagicMock()
        mock_result.scalar_one_or_none.return_value = None
        mock_db.execute.return_value = mock_result

        result = await find_by_email(mock_db, "missing@example.com")
        assert result is None

    @pytest.mark.asyncio
    async def test_find_by_id(self, mock_db: AsyncMock) -> None:
        user = _mock_user()
        mock_result = MagicMock()
        mock_result.scalar_one_or_none.return_value = user
        mock_db.execute.return_value = mock_result

        result = await find_by_id(mock_db, MOCK_USER_ID)
        assert result is user

    @pytest.mark.asyncio
    async def test_create_user(self, mock_db: AsyncMock) -> None:
        user = _mock_user()
        result = await create_user(mock_db, user)
        mock_db.add.assert_called_once_with(user)
        mock_db.flush.assert_called_once()
        mock_db.refresh.assert_called_once_with(user)
        assert result is user


# ---------------------------------------------------------------------------
# Service Tests
# ---------------------------------------------------------------------------


class TestAuthService:
    """Tests for src.auth.service functions."""

    @pytest.mark.asyncio
    @patch(f"{REPO}.find_by_email", new_callable=AsyncMock)
    async def test_login_or_create_existing_user(self, mock_find: AsyncMock) -> None:
        existing = _mock_user()
        mock_find.return_value = existing
        db = AsyncMock()
        user_info = OAuthUserInfo(id="google-123", email=MOCK_EMAIL, name="Test User")
        result = await login_or_create_user(db, provider="google", user_info=user_info)
        assert result is existing
        mock_find.assert_called_once_with(db, MOCK_EMAIL)

    @pytest.mark.asyncio
    @patch(f"{REPO}.create_user", new_callable=AsyncMock)
    @patch(f"{REPO}.find_by_email", new_callable=AsyncMock)
    async def test_login_or_create_new_user(
        self, mock_find: AsyncMock, mock_create: AsyncMock
    ) -> None:
        mock_find.return_value = None
        new_user = _mock_user()
        mock_create.return_value = new_user
        db = AsyncMock()
        user_info = OAuthUserInfo(
            id="google-456", email="new@example.com", name="New User"
        )
        result = await login_or_create_user(db, provider="google", user_info=user_info)
        assert result is new_user
        mock_create.assert_called_once()

    @pytest.mark.asyncio
    async def test_login_or_create_no_email_raises(self) -> None:
        db = AsyncMock()
        user_info = OAuthUserInfo(id="google-789", email=None)
        with pytest.raises(ValueError, match="email"):
            await login_or_create_user(db, provider="google", user_info=user_info)

    @pytest.mark.asyncio
    @patch(f"{REPO}.find_by_id", new_callable=AsyncMock)
    async def test_get_user_by_id_found(self, mock_find: AsyncMock) -> None:
        user = _mock_user()
        mock_find.return_value = user
        db = AsyncMock()
        result = await get_user_by_id(db, MOCK_USER_ID)
        assert result is user

    @pytest.mark.asyncio
    @patch(f"{REPO}.find_by_id", new_callable=AsyncMock)
    async def test_get_user_by_id_not_found(self, mock_find: AsyncMock) -> None:
        mock_find.return_value = None
        db = AsyncMock()
        result = await get_user_by_id(db, MOCK_USER_ID)
        assert result is None

    def test_issue_tokens(self) -> None:
        access, refresh = issue_tokens(str(MOCK_USER_ID), role="host")
        assert isinstance(access, str)
        assert isinstance(refresh, str)
        assert access != refresh


# ---------------------------------------------------------------------------
# Router Tests
# ---------------------------------------------------------------------------


class TestAuthRouter:
    """Tests for auth router endpoints."""

    @pytest.fixture(autouse=True)
    def _override_db(self) -> Generator[None, None, None]:
        async def _db_override() -> AsyncGenerator[AsyncMock, None]:
            yield AsyncMock()

        app.dependency_overrides[get_db] = _db_override
        yield
        app.dependency_overrides.clear()

    @patch(f"{SERVICE}.login_or_create_user", new_callable=AsyncMock)
    @patch(VERIFY_OAUTH, new_callable=AsyncMock)
    def test_login_success(
        self,
        mock_verify: AsyncMock,
        mock_login: AsyncMock,
        client: TestClient,
    ) -> None:
        mock_verify.return_value = OAuthUserInfo(
            id="google-123", email=MOCK_EMAIL, name="Test User"
        )
        mock_login.return_value = _mock_user()
        response = client.post(
            "/api/v1/auth/login",
            json={"provider": "google", "access_token": "fake-oauth-token"},
        )
        assert response.status_code == 200
        data = response.json()
        assert "access_token" in data
        assert "refresh_token" in data
        assert data["token_type"] == "bearer"  # noqa: S105

    @patch(f"{SERVICE}.login_or_create_user", new_callable=AsyncMock)
    @patch(VERIFY_OAUTH, new_callable=AsyncMock)
    def test_login_no_email_422(
        self,
        mock_verify: AsyncMock,
        mock_login: AsyncMock,
        client: TestClient,
    ) -> None:
        mock_verify.return_value = OAuthUserInfo(id="google-789", email=None)
        mock_login.side_effect = ValueError(
            "OAuth provider did not return an email address"
        )
        response = client.post(
            "/api/v1/auth/login",
            json={"provider": "google", "access_token": "fake-oauth-token"},
        )
        assert response.status_code == 422

    def test_login_missing_fields_422(self, client: TestClient) -> None:
        response = client.post("/api/v1/auth/login", json={})
        assert response.status_code == 422

    @patch(f"{SERVICE}.get_user_by_id", new_callable=AsyncMock)
    def test_refresh_success(
        self,
        mock_get_user: AsyncMock,
        client: TestClient,
    ) -> None:
        mock_get_user.return_value = _mock_user()
        refresh = create_refresh_token(str(MOCK_USER_ID))
        response = client.post(
            "/api/v1/auth/refresh",
            json={"refresh_token": refresh},
        )
        assert response.status_code == 200
        data = response.json()
        assert "access_token" in data
        assert data["refresh_token"] == refresh

    def test_refresh_invalid_token_type_401(self, client: TestClient) -> None:
        access = create_access_token(str(MOCK_USER_ID), role="host")
        response = client.post(
            "/api/v1/auth/refresh",
            json={"refresh_token": access},
        )
        assert response.status_code == 401

    @patch(f"{SERVICE}.get_user_by_id", new_callable=AsyncMock)
    def test_refresh_user_not_found_401(
        self,
        mock_get_user: AsyncMock,
        client: TestClient,
    ) -> None:
        mock_get_user.return_value = None
        refresh = create_refresh_token(str(MOCK_USER_ID))
        response = client.post(
            "/api/v1/auth/refresh",
            json={"refresh_token": refresh},
        )
        assert response.status_code == 401

    def test_refresh_invalid_token_401(self, client: TestClient) -> None:
        response = client.post(
            "/api/v1/auth/refresh",
            json={"refresh_token": "not-a-valid-jwe-token"},
        )
        assert response.status_code == 401

    def test_logout_204(self, client: TestClient) -> None:
        response = client.post("/api/v1/auth/logout")
        assert response.status_code == 204

    def test_logout_no_auth_required(self, client: TestClient) -> None:
        response = client.post("/api/v1/auth/logout")
        assert response.status_code == 204
        assert response.content == b""
