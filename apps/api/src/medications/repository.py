"""Data access layer for medications."""

import uuid
from datetime import date

from sqlalchemy import cast, func, select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.types import Date

from src.medications.model import Medication


async def create(
    db: AsyncSession,
    medication: Medication,
) -> Medication:
    """Persist a new medication entry."""
    db.add(medication)
    await db.flush()
    await db.refresh(medication)
    return medication


async def find_by_id(
    db: AsyncSession,
    medication_id: uuid.UUID,
) -> Medication | None:
    """Find a medication by primary key."""
    result = await db.execute(
        select(Medication).where(Medication.id == medication_id),
    )
    return result.scalar_one_or_none()


async def find_by_host(
    db: AsyncSession,
    host_id: uuid.UUID,
    *,
    limit: int = 20,
    offset: int = 0,
) -> tuple[list[Medication], int]:
    """Find medications for a host with pagination."""
    base = select(Medication).where(Medication.host_id == host_id)

    count_stmt = select(func.count()).select_from(base.subquery())
    total = (await db.execute(count_stmt)).scalar_one()

    stmt = base.order_by(Medication.schedule_time.desc())
    stmt = stmt.limit(limit).offset(offset)
    result = await db.execute(stmt)

    return list(result.scalars().all()), total


async def save(
    db: AsyncSession,
    medication: Medication,
) -> Medication:
    """Flush pending changes on a medication."""
    await db.flush()
    await db.refresh(medication)
    return medication


async def delete(
    db: AsyncSession,
    medication: Medication,
) -> None:
    """Hard-delete a medication entry."""
    await db.delete(medication)
    await db.flush()


async def find_by_host_and_pill_name(
    db: AsyncSession,
    host_id: uuid.UUID,
    pill_name: str,
) -> Medication | None:
    """Find the closest untaken medication matching pill_name for a host."""
    stmt = (
        select(Medication)
        .where(
            Medication.host_id == host_id,
            Medication.pill_name.ilike(f"%{pill_name}%"),
            Medication.is_taken.is_(False),
        )
        .order_by(Medication.schedule_time.asc())
        .limit(1)
    )
    result = await db.execute(stmt)
    return result.scalar_one_or_none()


async def count_adherence(
    db: AsyncSession,
    host_id: uuid.UUID,
    date_from: date,
    date_to: date,
) -> tuple[int, int]:
    """Count total and taken medications for a host within a date range.

    Returns (total, taken).
    """
    base = select(Medication).where(
        Medication.host_id == host_id,
        cast(Medication.schedule_time, Date) >= date_from,
        cast(Medication.schedule_time, Date) <= date_to,
    )

    total_result = await db.execute(select(func.count()).select_from(base.subquery()))
    total = total_result.scalar_one()

    taken_result = await db.execute(
        select(func.count()).select_from(
            base.where(Medication.is_taken.is_(True)).subquery()
        )
    )
    taken = taken_result.scalar_one()

    return total, taken
