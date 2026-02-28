from datetime import UTC, datetime, timedelta
from typing import Annotated, Literal

import httpx
import jwt
from fastapi import Depends, HTTPException, Request, status
from pydantic import BaseModel

from src.common.errors import AUTH_001, AUTH_002, AUTH_003, raise_api_error
from src.lib.config import settings
from src.lib.resilience import with_retry


class TokenPayload(BaseModel):
    """JWT token payload."""

    user_id: str
    token_type: Literal["access", "refresh"]
    exp: int
    iat: int
    role: str | None = None


class TokenResponse(BaseModel):
    """Token response."""

    access_token: str
    refresh_token: str
    token_type: str = "bearer"  # noqa: S105


class OAuthLoginRequest(BaseModel):
    """OAuth login request."""

    provider: Literal["google", "github", "facebook"]
    access_token: str


class RefreshTokenRequest(BaseModel):
    """Refresh token request."""

    refresh_token: str


class OAuthUserInfo(BaseModel):
    """OAuth user information from provider."""

    id: str
    email: str | None = None
    name: str | None = None
    image: str | None = None
    email_verified: bool = False


class CurrentUserInfo(BaseModel):
    """Current authenticated user info."""

    id: str
    role: str | None = None
    email: str | None = None
    name: str | None = None
    image: str | None = None
    email_verified: bool = False


def create_access_token(user_id: str, *, role: str | None = None) -> str:
    """Create JWT access token."""
    now = datetime.now(UTC)
    payload: dict[str, str | int] = {
        "user_id": user_id,
        "token_type": "access",
        "exp": int((now + timedelta(hours=1)).timestamp()),
        "iat": int(now.timestamp()),
    }
    if role is not None:
        payload["role"] = role

    return jwt.encode(payload, settings.JWT_SECRET, algorithm="HS256")


def create_refresh_token(user_id: str) -> str:
    """Create JWT refresh token."""
    now = datetime.now(UTC)
    payload: dict[str, str | int] = {
        "user_id": user_id,
        "token_type": "refresh",
        "exp": int((now + timedelta(days=7)).timestamp()),
        "iat": int(now.timestamp()),
    }

    return jwt.encode(payload, settings.JWT_SECRET, algorithm="HS256")


def decode_token(token: str) -> TokenPayload:
    """Decode and validate JWT token."""
    try:
        payload = jwt.decode(token, settings.JWT_SECRET, algorithms=["HS256"])
        return TokenPayload(**payload)
    except jwt.InvalidTokenError:
        raise_api_error(
            AUTH_002,
            status.HTTP_401_UNAUTHORIZED,
            headers={"WWW-Authenticate": "Bearer"},
        )


@with_retry()
async def verify_google_token(access_token: str) -> OAuthUserInfo:
    """Verify Google OAuth token."""
    async with httpx.AsyncClient() as client:
        response = await client.get(
            "https://www.googleapis.com/oauth2/v3/userinfo",
            headers={"Authorization": f"Bearer {access_token}"},
            timeout=5.0,
        )
        if response.status_code != 200:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid Google access token",
            )
        data = response.json()
        return OAuthUserInfo(
            id=data["sub"],
            email=data["email"],
            name=data.get("name"),
            image=data.get("picture"),
            email_verified=data.get("email_verified", False),
        )


@with_retry()
async def verify_github_token(access_token: str) -> OAuthUserInfo:
    """Verify GitHub OAuth token."""
    async with httpx.AsyncClient() as client:
        response = await client.get(
            "https://api.github.com/user",
            headers={"Authorization": f"Bearer {access_token}"},
            timeout=5.0,
        )
        if response.status_code != 200:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid GitHub access token",
            )
        data = response.json()
        return OAuthUserInfo(
            id=str(data["id"]),
            email=data.get("email"),
            name=data.get("name"),
            image=data.get("avatar_url"),
        )


@with_retry()
async def verify_facebook_token(access_token: str) -> OAuthUserInfo:
    """Verify Facebook OAuth token."""
    async with httpx.AsyncClient() as client:
        response = await client.get(
            "https://graph.facebook.com/me?fields=id,email,name,picture",
            headers={"Authorization": f"Bearer {access_token}"},
            timeout=5.0,
        )
        if response.status_code != 200:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid Facebook access token",
            )
        data = response.json()
        picture_url = data.get("picture", {}).get("data", {}).get("url")
        return OAuthUserInfo(
            id=data["id"],
            email=data.get("email"),
            name=data.get("name"),
            image=picture_url,
        )


async def verify_oauth_token(provider: str, access_token: str) -> OAuthUserInfo:
    """Verify OAuth token based on provider."""
    if provider == "google":
        return await verify_google_token(access_token)
    elif provider == "github":
        return await verify_github_token(access_token)
    elif provider == "facebook":
        return await verify_facebook_token(access_token)
    else:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Unsupported provider: {provider}",
        )


async def get_current_user(request: Request) -> CurrentUserInfo:
    """Get current authenticated user from Authorization header."""
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        raise_api_error(
            AUTH_001,
            status.HTTP_401_UNAUTHORIZED,
            headers={"WWW-Authenticate": "Bearer"},
        )

    token = auth_header.replace("Bearer ", "")
    payload = decode_token(token)

    if payload.token_type != "access":  # noqa: S105
        raise_api_error(AUTH_003, status.HTTP_401_UNAUTHORIZED)

    return CurrentUserInfo(id=payload.user_id, role=payload.role)


async def get_optional_user(request: Request) -> CurrentUserInfo | None:
    """Get current user if authenticated, otherwise None."""
    try:
        return await get_current_user(request)
    except HTTPException:
        return None


CurrentUser = Annotated[CurrentUserInfo, Depends(get_current_user)]
OptionalUser = Annotated[CurrentUserInfo | None, Depends(get_optional_user)]
