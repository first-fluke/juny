"""Business logic for users."""

import uuid

from sqlalchemy.ext.asyncio import AsyncSession

from src.common.enums import UserRole
from src.users import repository
from src.users.model import User
from src.users.schemas import UserRoleUpdate, UserUpdate

_VALID_ROLES = {r.value for r in UserRole}


async def get_user(db: AsyncSession, user_id: uuid.UUID) -> User | None:
    """Retrieve a single user by ID."""
    return await repository.find_by_id(db, user_id)


async def update_user(
    db: AsyncSession,
    user: User,
    payload: UserUpdate,
) -> User:
    """Update mutable profile fields (name, image)."""
    if payload.name is not None:
        user.name = payload.name
    if payload.image is not None:
        user.image = payload.image
    return await repository.save(db, user)


async def update_user_role(
    db: AsyncSession,
    user: User,
    payload: UserRoleUpdate,
) -> User:
    """Change a user's role (admin-only)."""
    if payload.role not in _VALID_ROLES:
        raise ValueError(f"Invalid role: {payload.role}. Must be one of {_VALID_ROLES}")
    user.role = payload.role
    return await repository.save(db, user)


async def list_users(
    db: AsyncSession,
    *,
    limit: int,
    offset: int,
) -> tuple[list[User], int]:
    """List users with pagination."""
    return await repository.list_paginated(db, limit=limit, offset=offset)


async def delete_user(db: AsyncSession, user: User) -> None:
    """Delete a user."""
    await repository.delete(db, user)
