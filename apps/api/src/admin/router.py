"""Admin endpoints for internal service-to-service calls."""

from uuid import UUID

from fastapi import APIRouter, Query

from src.admin import service
from src.admin.schemas import (
    CleanupRequest,
    CleanupResponse,
    InactiveRelationResponse,
    WellnessAggregateResponse,
)
from src.lib.dependencies import DBSession
from src.lib.internal_auth import InternalAuth

router = APIRouter()


@router.post(
    "/cleanup",
    response_model=CleanupResponse,
    dependencies=[InternalAuth],
)
async def cleanup_data(
    payload: CleanupRequest,
    db: DBSession,
) -> CleanupResponse:
    """Clean up old data based on retention policy."""
    return await service.cleanup_data(db, payload.retention_days, payload.resource_type)


@router.get(
    "/inactive-relations",
    response_model=list[InactiveRelationResponse],
    dependencies=[InternalAuth],
)
async def list_inactive_relations(
    db: DBSession,
    threshold_days: int = Query(30),
) -> list[InactiveRelationResponse]:
    """List care relations with no recent wellness activity."""
    return await service.get_inactive_relations(db, threshold_days)


@router.get(
    "/wellness/aggregate",
    response_model=WellnessAggregateResponse,
    dependencies=[InternalAuth],
)
async def wellness_aggregate(
    db: DBSession,
    host_id: UUID = Query(...),
    date: str = Query(...),
) -> WellnessAggregateResponse:
    """Get daily wellness statistics for a host."""
    return await service.get_wellness_aggregate(db, host_id, date)
