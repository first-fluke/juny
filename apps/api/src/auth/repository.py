"""Data access layer for authentication."""

import uuid

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from src.users.model import User


async def find_by_email(
    db: AsyncSession,
    email: str,
) -> User | None:
    """Find a user by email address."""
    result = await db.execute(select(User).where(User.email == email))
    return result.scalar_one_or_none()


async def find_by_id(
    db: AsyncSession,
    user_id: uuid.UUID,
) -> User | None:
    """Find a user by primary key."""
    result = await db.execute(select(User).where(User.id == user_id))
    return result.scalar_one_or_none()


async def create_user(
    db: AsyncSession,
    user: User,
) -> User:
    """Persist a new user."""
    db.add(user)
    await db.flush()
    await db.refresh(user)
    return user
