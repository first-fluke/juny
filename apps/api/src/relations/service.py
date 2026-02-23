"""Business logic for care relations."""

import uuid

from sqlalchemy.ext.asyncio import AsyncSession

from src.relations import repository
from src.relations.model import CareRelation
from src.relations.schemas import (
    CAREGIVER_ROLES,
    CareRelationCreate,
    CareRelationUpdate,
)


async def create_relation(
    db: AsyncSession,
    payload: CareRelationCreate,
) -> CareRelation:
    """Validate and create a new care relation."""
    if payload.role not in CAREGIVER_ROLES:
        msg = (
            f"Invalid caregiver role: {payload.role}. Must be one of {CAREGIVER_ROLES}"
        )
        raise ValueError(msg)

    if payload.host_id == payload.caregiver_id:
        raise ValueError("host_id and caregiver_id must differ")

    relation = CareRelation(
        host_id=payload.host_id,
        caregiver_id=payload.caregiver_id,
        role=payload.role,
    )
    return await repository.create(db, relation)


async def list_relations_for_host(
    db: AsyncSession,
    host_id: uuid.UUID,
    *,
    active_only: bool = True,
) -> list[CareRelation]:
    """List all care relations where user is host."""
    return await repository.find_by_host(db, host_id, active_only=active_only)


async def list_relations_for_caregiver(
    db: AsyncSession,
    caregiver_id: uuid.UUID,
    *,
    active_only: bool = True,
) -> list[CareRelation]:
    """List all care relations where user is caregiver."""
    return await repository.find_by_caregiver(db, caregiver_id, active_only=active_only)


async def get_relation(
    db: AsyncSession,
    relation_id: uuid.UUID,
) -> CareRelation | None:
    """Get a single care relation by ID."""
    return await repository.find_by_id(db, relation_id)


async def update_relation(
    db: AsyncSession,
    relation: CareRelation,
    payload: CareRelationUpdate,
) -> CareRelation:
    """Validate and apply updates to a care relation."""
    if payload.role is not None:
        if payload.role not in CAREGIVER_ROLES:
            msg = (
                f"Invalid caregiver role: {payload.role}. "
                f"Must be one of {CAREGIVER_ROLES}"
            )
            raise ValueError(msg)
        relation.role = payload.role
    if payload.is_active is not None:
        relation.is_active = payload.is_active
    return await repository.save(db, relation)


async def delete_relation(
    db: AsyncSession,
    relation: CareRelation,
) -> None:
    """Delete a care relation."""
    await repository.delete(db, relation)
