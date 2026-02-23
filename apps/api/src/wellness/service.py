"""Business logic for wellness logs."""

import uuid

from sqlalchemy.ext.asyncio import AsyncSession

from src.wellness import repository
from src.wellness.model import WellnessLog
from src.wellness.schemas import WellnessLogCreate


async def create_wellness_log(
    db: AsyncSession,
    payload: WellnessLogCreate,
) -> WellnessLog:
    """Create a new wellness log entry (append-only)."""
    log_entry = WellnessLog(
        host_id=payload.host_id,
        status=payload.status.value,
        summary=payload.summary,
        details=payload.details,
    )
    return await repository.create(db, log_entry)


async def list_wellness_logs(
    db: AsyncSession,
    host_id: uuid.UUID,
    *,
    limit: int = 20,
    offset: int = 0,
) -> tuple[list[WellnessLog], int]:
    """List wellness logs for a host with pagination."""
    return await repository.find_by_host(db, host_id, limit=limit, offset=offset)


async def get_wellness_log(
    db: AsyncSession,
    log_id: uuid.UUID,
) -> WellnessLog | None:
    """Get a single wellness log by ID."""
    return await repository.find_by_id(db, log_id)
