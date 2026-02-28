"""Data access layer for wellness logs."""

import uuid
from datetime import date

from sqlalchemy import Row, cast, func, select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.types import Date

from src.wellness.model import WellnessLog


async def create(
    db: AsyncSession,
    log_entry: WellnessLog,
) -> WellnessLog:
    """Persist a new wellness log entry."""
    db.add(log_entry)
    await db.flush()
    await db.refresh(log_entry)
    return log_entry


async def find_by_id(
    db: AsyncSession,
    log_id: uuid.UUID,
) -> WellnessLog | None:
    """Find a wellness log by primary key."""
    result = await db.execute(
        select(WellnessLog).where(WellnessLog.id == log_id),
    )
    return result.scalar_one_or_none()


async def find_by_host(
    db: AsyncSession,
    host_id: uuid.UUID,
    *,
    limit: int = 20,
    offset: int = 0,
) -> tuple[list[WellnessLog], int]:
    """Find wellness logs for a host with pagination."""
    base = select(WellnessLog).where(
        WellnessLog.host_id == host_id,
    )

    count_stmt = select(func.count()).select_from(base.subquery())
    total = (await db.execute(count_stmt)).scalar_one()

    stmt = base.order_by(WellnessLog.created_at.desc())
    stmt = stmt.limit(limit).offset(offset)
    result = await db.execute(stmt)

    return list(result.scalars().all()), total


async def aggregate_trend(
    db: AsyncSession,
    host_id: uuid.UUID,
    date_from: date,
    date_to: date,
) -> list[Row[tuple[date, str, int]]]:
    """Group wellness logs by date and status for a host within a date range.

    Returns rows of (date, status, count).
    """
    log_date = cast(WellnessLog.created_at, Date).label("log_date")
    stmt = (
        select(
            log_date,
            WellnessLog.status,
            func.count().label("count"),
        )
        .where(
            WellnessLog.host_id == host_id,
            cast(WellnessLog.created_at, Date) >= date_from,
            cast(WellnessLog.created_at, Date) <= date_to,
        )
        .group_by(log_date, WellnessLog.status)
        .order_by(log_date)
    )
    result = await db.execute(stmt)
    return list(result.all())
