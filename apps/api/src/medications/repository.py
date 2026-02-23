"""Data access layer for medications."""

import uuid

from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession

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
