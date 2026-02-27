"""Data access layer for device tokens."""

import uuid

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from src.notifications.model import DeviceToken


async def find_by_user(
    db: AsyncSession,
    user_id: uuid.UUID,
    *,
    active_only: bool = True,
) -> list[DeviceToken]:
    """Return all device tokens for a user."""
    stmt = select(DeviceToken).where(DeviceToken.user_id == user_id)
    if active_only:
        stmt = stmt.where(DeviceToken.is_active.is_(True))
    result = await db.execute(stmt)
    return list(result.scalars().all())


async def find_by_token(
    db: AsyncSession,
    token: str,
) -> DeviceToken | None:
    """Find a device token by its raw token string."""
    result = await db.execute(select(DeviceToken).where(DeviceToken.token == token))
    return result.scalar_one_or_none()


async def find_by_id(
    db: AsyncSession,
    token_id: uuid.UUID,
) -> DeviceToken | None:
    """Find a device token by primary key."""
    result = await db.execute(select(DeviceToken).where(DeviceToken.id == token_id))
    return result.scalar_one_or_none()


async def create(db: AsyncSession, device_token: DeviceToken) -> DeviceToken:
    """Persist a new device token."""
    db.add(device_token)
    await db.flush()
    await db.refresh(device_token)
    return device_token


async def deactivate(db: AsyncSession, device_token: DeviceToken) -> DeviceToken:
    """Mark a device token as inactive."""
    device_token.is_active = False
    await db.flush()
    await db.refresh(device_token)
    return device_token


async def deactivate_tokens(db: AsyncSession, tokens: list[str]) -> None:
    """Deactivate multiple tokens by their raw string values."""
    if not tokens:
        return
    for token_str in tokens:
        dt = await find_by_token(db, token_str)
        if dt and dt.is_active:
            dt.is_active = False
    await db.flush()
