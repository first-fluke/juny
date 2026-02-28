"""Data access layer for notification logs and preferences."""

import uuid

from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession

from src.notification_logs.model import NotificationLog, NotificationPreference


async def create_log(db: AsyncSession, log: NotificationLog) -> NotificationLog:
    """Persist a new notification log."""
    db.add(log)
    await db.flush()
    await db.refresh(log)
    return log


async def find_log_by_id(
    db: AsyncSession,
    log_id: uuid.UUID,
) -> NotificationLog | None:
    """Find a notification log by primary key."""
    result = await db.execute(
        select(NotificationLog).where(NotificationLog.id == log_id)
    )
    return result.scalar_one_or_none()


async def find_logs_by_recipient(
    db: AsyncSession,
    recipient_id: uuid.UUID,
    *,
    limit: int = 20,
    offset: int = 0,
) -> tuple[list[NotificationLog], int]:
    """List notification logs for a user (newest first) with total count."""
    base = select(NotificationLog).where(NotificationLog.recipient_id == recipient_id)
    count_result = await db.execute(select(func.count()).select_from(base.subquery()))
    total = count_result.scalar_one()

    rows = await db.execute(
        base.order_by(NotificationLog.created_at.desc()).limit(limit).offset(offset)
    )
    return list(rows.scalars().all()), total


async def save_log(db: AsyncSession, log: NotificationLog) -> NotificationLog:
    """Flush changes to an existing notification log."""
    await db.flush()
    await db.refresh(log)
    return log


async def find_preference_by_user(
    db: AsyncSession,
    user_id: uuid.UUID,
) -> NotificationPreference | None:
    """Find notification preferences for a user."""
    result = await db.execute(
        select(NotificationPreference).where(NotificationPreference.user_id == user_id)
    )
    return result.scalar_one_or_none()


async def save_preference(
    db: AsyncSession,
    pref: NotificationPreference,
) -> NotificationPreference:
    """Persist or update a notification preference."""
    db.add(pref)
    await db.flush()
    await db.refresh(pref)
    return pref
