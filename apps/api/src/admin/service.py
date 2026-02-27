"""Admin business logic."""

from datetime import UTC, datetime, timedelta
from uuid import UUID

from sqlalchemy.ext.asyncio import AsyncSession

from src.admin import repository
from src.admin.schemas import (
    CleanupResponse,
    InactiveRelationResponse,
    WellnessAggregateResponse,
)


async def cleanup_data(
    db: AsyncSession, retention_days: int, resource_type: str
) -> CleanupResponse:
    """Orchestrate data cleanup based on retention policy."""
    before = datetime.now(UTC) - timedelta(days=retention_days)

    deleted_logs = 0
    deactivated = 0

    if resource_type in ("all", "wellness_logs"):
        deleted_logs = await repository.delete_old_wellness_logs(db, before)

    if resource_type in ("all", "device_tokens"):
        deactivated = await repository.deactivate_old_tokens(db, before)

    await db.commit()
    return CleanupResponse(
        deleted_wellness_logs=deleted_logs,
        deactivated_tokens=deactivated,
    )


async def get_inactive_relations(
    db: AsyncSession, threshold_days: int
) -> list[InactiveRelationResponse]:
    """Fetch inactive relations and convert to DTOs."""
    rows = await repository.find_inactive_relations(db, threshold_days)
    return [
        InactiveRelationResponse(
            relation_id=row.relation_id,
            host_id=row.host_id,
            caregiver_id=row.caregiver_id,
            role=row.role,
            last_wellness_at=row.last_wellness_at,
            inactive_days=int(row.inactive_days),
        )
        for row in rows
    ]


async def get_wellness_aggregate(
    db: AsyncSession, host_id: UUID, date: str
) -> WellnessAggregateResponse:
    """Compute daily wellness statistics for a host."""
    by_status = await repository.aggregate_wellness(db, host_id, date)
    total = sum(by_status.values())
    return WellnessAggregateResponse(
        host_id=host_id,
        date=date,
        total_logs=total,
        by_status=by_status,
    )
