"""Business logic for wellness logs."""

import uuid
from datetime import date

from sqlalchemy.ext.asyncio import AsyncSession

from src.wellness import repository
from src.wellness.model import WellnessLog
from src.wellness.schemas import (
    DailyWellnessStat,
    WellnessLogCreate,
    WellnessTrendResponse,
)


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


async def get_wellness_trend(
    db: AsyncSession,
    host_id: uuid.UUID,
    date_from: date,
    date_to: date,
) -> WellnessTrendResponse:
    """Aggregate wellness logs into daily trend statistics."""
    rows = await repository.aggregate_trend(db, host_id, date_from, date_to)

    daily: dict[str, DailyWellnessStat] = {}
    for row in rows:
        d = str(row[0])
        if d not in daily:
            daily[d] = DailyWellnessStat(date=d)
        stat = daily[d]
        status_name = row[1]
        count = row[2]
        if status_name == "normal":
            stat.normal = count
        elif status_name == "warning":
            stat.warning = count
        elif status_name == "emergency":
            stat.emergency = count

    return WellnessTrendResponse(
        host_id=host_id,
        date_from=str(date_from),
        date_to=str(date_to),
        daily_stats=list(daily.values()),
    )
