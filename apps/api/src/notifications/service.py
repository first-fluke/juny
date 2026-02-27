"""Business logic for device token management."""

import uuid

from sqlalchemy.ext.asyncio import AsyncSession

from src.notifications import repository
from src.notifications.model import DeviceToken
from src.notifications.schemas import DeviceTokenCreate


async def register_token(
    db: AsyncSession,
    user_id: uuid.UUID,
    payload: DeviceTokenCreate,
) -> DeviceToken:
    """Register a new device token, or reactivate an existing one."""
    existing = await repository.find_by_token(db, payload.token)
    if existing:
        # Reactivate if owned by same user, or reassign
        existing.user_id = user_id
        existing.platform = payload.platform
        existing.is_active = True
        await db.flush()
        await db.refresh(existing)
        return existing

    device_token = DeviceToken(
        user_id=user_id,
        token=payload.token,
        platform=payload.platform,
    )
    return await repository.create(db, device_token)


async def unregister_token(
    db: AsyncSession,
    token_id: uuid.UUID,
    user_id: uuid.UUID,
) -> DeviceToken | None:
    """Deactivate a device token if owned by the user."""
    device_token = await repository.find_by_id(db, token_id)
    if not device_token or device_token.user_id != user_id:
        return None
    return await repository.deactivate(db, device_token)


async def get_user_tokens(
    db: AsyncSession,
    user_id: uuid.UUID,
) -> list[DeviceToken]:
    """Return all active device tokens for a user."""
    return await repository.find_by_user(db, user_id)


async def get_user_token_strings(
    db: AsyncSession,
    user_id: uuid.UUID,
) -> list[str]:
    """Return raw FCM token strings for a user."""
    tokens = await repository.find_by_user(db, user_id)
    return [t.token for t in tokens]
