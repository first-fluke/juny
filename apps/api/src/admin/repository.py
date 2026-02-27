"""Admin-specific database queries."""

from datetime import datetime
from typing import Any
from uuid import UUID

from sqlalchemy import Row, delete, func, select, update
from sqlalchemy.ext.asyncio import AsyncSession

from src.notifications.model import DeviceToken
from src.relations.model import CareRelation
from src.wellness.model import WellnessLog


async def delete_old_wellness_logs(db: AsyncSession, before: datetime) -> int:
    """Delete wellness_logs created before the given datetime. Returns deleted count."""
    result = await db.execute(
        delete(WellnessLog).where(WellnessLog.created_at < before)
    )
    return result.rowcount  # type: ignore[no-any-return,attr-defined]


async def deactivate_old_tokens(db: AsyncSession, before: datetime) -> int:
    """Deactivate device tokens not updated since the given datetime."""
    result = await db.execute(
        update(DeviceToken)
        .where(DeviceToken.is_active.is_(True), DeviceToken.updated_at < before)
        .values(is_active=False)
    )
    return result.rowcount  # type: ignore[no-any-return,attr-defined]


async def find_inactive_relations(
    db: AsyncSession, threshold_days: int
) -> list[Row[Any]]:
    """Find active care relations whose host has no recent wellness logs.

    LEFT JOIN wellness_logs, GROUP BY relation, HAVING max(created_at) < threshold.
    """
    cutoff = func.now() - func.make_interval(0, 0, 0, threshold_days)

    latest_wellness = func.max(WellnessLog.created_at).label("last_wellness_at")
    inactive_days_expr = func.coalesce(
        func.extract(
            "day",
            func.now() - func.max(WellnessLog.created_at),
        ),
        threshold_days,
    ).label("inactive_days")

    stmt = (
        select(
            CareRelation.id.label("relation_id"),
            CareRelation.host_id,
            CareRelation.caregiver_id,
            CareRelation.role,
            latest_wellness,
            inactive_days_expr,
        )
        .outerjoin(WellnessLog, CareRelation.host_id == WellnessLog.host_id)
        .where(CareRelation.is_active.is_(True))
        .group_by(
            CareRelation.id,
            CareRelation.host_id,
            CareRelation.caregiver_id,
            CareRelation.role,
        )
        .having(
            (func.max(WellnessLog.created_at) < cutoff)
            | (func.max(WellnessLog.created_at).is_(None))
        )
    )
    result = await db.execute(stmt)
    return list(result.all())


async def aggregate_wellness(
    db: AsyncSession, host_id: UUID, date: str
) -> dict[str, int]:
    """Aggregate wellness logs by status for a host on a specific date.

    Returns dict like {"normal": 5, "warning": 1, "emergency": 0}.
    """
    stmt = (
        select(WellnessLog.status, func.count().label("count"))
        .where(
            WellnessLog.host_id == host_id,
            func.date(WellnessLog.created_at) == date,
        )
        .group_by(WellnessLog.status)
    )
    result = await db.execute(stmt)
    return dict(result.all())  # type: ignore[arg-type]
