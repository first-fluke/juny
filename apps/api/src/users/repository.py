"""Data access layer for users."""

import uuid

from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession

from src.users.model import User


async def find_by_id(
    db: AsyncSession,
    user_id: uuid.UUID,
) -> User | None:
    """Find a user by primary key."""
    result = await db.execute(select(User).where(User.id == user_id))
    return result.scalar_one_or_none()


async def find_by_email(
    db: AsyncSession,
    email: str,
) -> User | None:
    """Find a user by email address."""
    result = await db.execute(select(User).where(User.email == email))
    return result.scalar_one_or_none()


async def list_paginated(
    db: AsyncSession,
    *,
    limit: int,
    offset: int,
) -> tuple[list[User], int]:
    """Return a page of users and the total count."""
    total_result = await db.execute(select(func.count()).select_from(User))
    total = total_result.scalar_one()

    rows_result = await db.execute(
        select(User).order_by(User.created_at.desc()).limit(limit).offset(offset)
    )
    users = list(rows_result.scalars().all())
    return users, total


async def save(db: AsyncSession, user: User) -> User:
    """Flush and refresh a user instance."""
    db.add(user)
    await db.flush()
    await db.refresh(user)
    return user


async def delete(db: AsyncSession, user: User) -> None:
    """Delete a user."""
    await db.delete(user)
    await db.flush()
