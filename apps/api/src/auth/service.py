"""Business logic for authentication."""

import uuid

from sqlalchemy.ext.asyncio import AsyncSession

from src.auth import repository
from src.lib.auth import (
    OAuthUserInfo,
    create_access_token,
    create_refresh_token,
)
from src.users.model import User


async def login_or_create_user(
    db: AsyncSession,
    *,
    provider: str,
    user_info: OAuthUserInfo,
) -> User:
    """Find existing user by email or create a new one.

    Returns the user instance (existing or newly created).
    """
    if not user_info.email:
        msg = "OAuth provider did not return an email address"
        raise ValueError(msg)

    user = await repository.find_by_email(db, user_info.email)

    if not user:
        user = User(
            email=user_info.email,
            name=user_info.name,
            image=user_info.image,
            email_verified=user_info.email_verified,
            provider=provider,
            provider_id=user_info.id,
        )
        user = await repository.create_user(db, user)

    return user


async def get_user_by_id(
    db: AsyncSession,
    user_id: uuid.UUID,
) -> User | None:
    """Get a user by ID."""
    return await repository.find_by_id(db, user_id)


def issue_tokens(user_id: str, *, role: str | None = None) -> tuple[str, str]:
    """Issue a pair of access + refresh tokens for a user."""
    return create_access_token(user_id, role=role), create_refresh_token(user_id)
