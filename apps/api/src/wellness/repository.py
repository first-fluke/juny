"""Data access layer for wellness logs."""

import uuid

from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession

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
