"""Business logic for notification logs and preferences."""

import uuid

from sqlalchemy.ext.asyncio import AsyncSession

from src.notification_logs import repository
from src.notification_logs.model import NotificationLog, NotificationPreference
from src.notification_logs.schemas import NotificationPreferenceUpdate


async def list_logs(
    db: AsyncSession,
    recipient_id: uuid.UUID,
    *,
    limit: int = 20,
    offset: int = 0,
) -> tuple[list[NotificationLog], int]:
    """List notification logs for a user with pagination."""
    return await repository.find_logs_by_recipient(
        db, recipient_id, limit=limit, offset=offset
    )


async def get_log(
    db: AsyncSession,
    log_id: uuid.UUID,
) -> NotificationLog | None:
    """Get a single notification log by ID."""
    return await repository.find_log_by_id(db, log_id)


async def update_log_status(
    db: AsyncSession,
    log: NotificationLog,
    status: str,
) -> NotificationLog:
    """Update the delivery status of a notification log."""
    log.status = status
    return await repository.save_log(db, log)


async def get_preferences(
    db: AsyncSession,
    user_id: uuid.UUID,
) -> NotificationPreference:
    """Get or create default notification preferences for a user."""
    pref = await repository.find_preference_by_user(db, user_id)
    if pref is None:
        pref = NotificationPreference(user_id=user_id)
        pref = await repository.save_preference(db, pref)
    return pref


async def update_preferences(
    db: AsyncSession,
    user_id: uuid.UUID,
    payload: NotificationPreferenceUpdate,
) -> NotificationPreference:
    """Update notification preferences for a user."""
    pref = await repository.find_preference_by_user(db, user_id)
    if pref is None:
        pref = NotificationPreference(user_id=user_id)

    if payload.wellness_alerts is not None:
        pref.wellness_alerts = payload.wellness_alerts
    if payload.medication_reminders is not None:
        pref.medication_reminders = payload.medication_reminders
    if payload.system_updates is not None:
        pref.system_updates = payload.system_updates

    return await repository.save_preference(db, pref)
