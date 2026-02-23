"""Business logic for medications."""

import uuid
from datetime import UTC, datetime

from sqlalchemy.ext.asyncio import AsyncSession

from src.medications import repository
from src.medications.model import Medication
from src.medications.schemas import MedicationCreate, MedicationUpdate


async def create_medication(
    db: AsyncSession,
    payload: MedicationCreate,
) -> Medication:
    """Create a new medication schedule entry."""
    medication = Medication(
        host_id=payload.host_id,
        pill_name=payload.pill_name,
        schedule_time=payload.schedule_time,
    )
    return await repository.create(db, medication)


async def list_medications(
    db: AsyncSession,
    host_id: uuid.UUID,
    *,
    limit: int = 20,
    offset: int = 0,
) -> tuple[list[Medication], int]:
    """List medications for a host with pagination."""
    return await repository.find_by_host(db, host_id, limit=limit, offset=offset)


async def get_medication(
    db: AsyncSession,
    medication_id: uuid.UUID,
) -> Medication | None:
    """Get a single medication by ID."""
    return await repository.find_by_id(db, medication_id)


async def update_medication(
    db: AsyncSession,
    medication: Medication,
    payload: MedicationUpdate,
) -> Medication:
    """Apply business rules and update a medication entry."""
    if payload.pill_name is not None:
        medication.pill_name = payload.pill_name
    if payload.schedule_time is not None:
        medication.schedule_time = payload.schedule_time
    if payload.is_taken is not None:
        medication.is_taken = payload.is_taken
        if payload.is_taken:
            medication.taken_at = datetime.now(UTC)
        else:
            medication.taken_at = None
    return await repository.save(db, medication)


async def delete_medication(
    db: AsyncSession,
    medication: Medication,
) -> None:
    """Delete a medication entry."""
    await repository.delete(db, medication)
