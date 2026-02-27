from uuid import UUID

from fastapi import APIRouter, Request, status

from src.auth import service
from src.common.errors import AUTH_002, AUTH_003, SVC_003, raise_api_error
from src.lib.auth import (
    OAuthLoginRequest,
    RefreshTokenRequest,
    TokenResponse,
    decode_token,
    verify_oauth_token,
)
from src.lib.dependencies import DBSession
from src.lib.rate_limit import rate_limit

router = APIRouter()


@router.post("/login", response_model=TokenResponse)
@rate_limit(requests=10, window=60)
async def login(
    request: Request,
    payload: OAuthLoginRequest,
    db: DBSession,
) -> TokenResponse:
    """OAuth login endpoint.

    Verify OAuth token, create/update user, and issue JWT tokens.
    """
    user_info = await verify_oauth_token(payload.provider, payload.access_token)

    try:
        user = await service.login_or_create_user(
            db,
            provider=payload.provider,
            user_info=user_info,
        )
    except ValueError as e:
        raise_api_error(
            SVC_003,
            status.HTTP_422_UNPROCESSABLE_CONTENT,
            message=str(e),
        )

    access_token, refresh_token = service.issue_tokens(str(user.id), role=user.role)

    return TokenResponse(
        access_token=access_token,
        refresh_token=refresh_token,
    )


@router.post("/refresh", response_model=TokenResponse)
@rate_limit(requests=20, window=60)
async def refresh_token(
    request: Request,
    body: RefreshTokenRequest,
    db: DBSession,
) -> TokenResponse:
    """Refresh access token using refresh token."""
    token_payload = decode_token(body.refresh_token)

    if token_payload.token_type != "refresh":  # noqa: S105
        raise_api_error(AUTH_003, status.HTTP_401_UNAUTHORIZED)

    user = await service.get_user_by_id(db, UUID(token_payload.user_id))
    if not user:
        raise_api_error(AUTH_002, status.HTTP_401_UNAUTHORIZED)

    access_token, _ = service.issue_tokens(str(user.id), role=user.role)

    return TokenResponse(
        access_token=access_token,
        refresh_token=body.refresh_token,
    )


@router.post("/logout", status_code=status.HTTP_204_NO_CONTENT)
async def logout() -> None:
    """Logout endpoint.

    Client should remove tokens from localStorage.
    """
    return None
