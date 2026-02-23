"""Data access layer for care relations."""

import uuid

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from src.relations.model import CareRelation


async def create(
    db: AsyncSession,
    relation: CareRelation,
) -> CareRelation:
    """Persist a new care relation."""
    db.add(relation)
    await db.flush()
    await db.refresh(relation)
    return relation


async def find_by_id(
    db: AsyncSession,
    relation_id: uuid.UUID,
) -> CareRelation | None:
    """Find a care relation by primary key."""
    result = await db.execute(
        select(CareRelation).where(CareRelation.id == relation_id),
    )
    return result.scalar_one_or_none()


async def find_by_host(
    db: AsyncSession,
    host_id: uuid.UUID,
    *,
    active_only: bool = True,
) -> list[CareRelation]:
    """Find all care relations for a given host."""
    stmt = select(CareRelation).where(
        CareRelation.host_id == host_id,
    )
    if active_only:
        stmt = stmt.where(CareRelation.is_active.is_(True))
    result = await db.execute(stmt)
    return list(result.scalars().all())


async def find_by_caregiver(
    db: AsyncSession,
    caregiver_id: uuid.UUID,
    *,
    active_only: bool = True,
) -> list[CareRelation]:
    """Find all care relations for a given caregiver."""
    stmt = select(CareRelation).where(
        CareRelation.caregiver_id == caregiver_id,
    )
    if active_only:
        stmt = stmt.where(CareRelation.is_active.is_(True))
    result = await db.execute(stmt)
    return list(result.scalars().all())


async def save(
    db: AsyncSession,
    relation: CareRelation,
) -> CareRelation:
    """Flush pending changes on a relation."""
    await db.flush()
    await db.refresh(relation)
    return relation


async def delete(
    db: AsyncSession,
    relation: CareRelation,
) -> None:
    """Hard-delete a care relation."""
    await db.delete(relation)
    await db.flush()
