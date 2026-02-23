from uuid import UUID

from fastapi import APIRouter, HTTPException, status

from src.auth import service
from src.lib.auth import (
    OAuthLoginRequest,
    RefreshTokenRequest,
    TokenResponse,
    decode_token,
    verify_oauth_token,
)
from src.lib.dependencies import DBSession

router = APIRouter()


@router.post("/login", response_model=TokenResponse)
async def login(
    request: OAuthLoginRequest,
    db: DBSession,
) -> TokenResponse:
    """OAuth login endpoint.

    Verify OAuth token, create/update user, and issue JWE tokens.
    """
    user_info = await verify_oauth_token(request.provider, request.access_token)

    try:
        user = await service.login_or_create_user(
            db,
            provider=request.provider,
            user_info=user_info,
        )
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_CONTENT,
            detail=str(e),
        ) from e

    access_token, refresh_token = service.issue_tokens(str(user.id), role=user.role)

    return TokenResponse(
        access_token=access_token,
        refresh_token=refresh_token,
    )


@router.post("/refresh", response_model=TokenResponse)
async def refresh_token(
    request: RefreshTokenRequest,
    db: DBSession,
) -> TokenResponse:
    """Refresh access token using refresh token."""
    payload = decode_token(request.refresh_token)

    if payload.token_type != "refresh":  # noqa: S105
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token type",
        )

    user = await service.get_user_by_id(db, UUID(payload.user_id))
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="User not found",
        )

    access_token, _ = service.issue_tokens(str(user.id), role=user.role)

    return TokenResponse(
        access_token=access_token,
        refresh_token=request.refresh_token,
    )


@router.post("/logout", status_code=status.HTTP_204_NO_CONTENT)
async def logout() -> None:
    """Logout endpoint.

    Client should remove tokens from localStorage.
    """
    return None
