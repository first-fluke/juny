"""Admin endpoints for internal service-to-service calls."""

from typing import Any
from uuid import UUID

from fastapi import APIRouter, Query

from src.admin import service
from src.admin.schemas import (
    AuditLogResponse,
    CleanupRequest,
    CleanupResponse,
    InactiveRelationResponse,
    TokenDeactivateRequest,
    TokenDeactivateResponse,
    WellnessAggregateResponse,
)
from src.common.models import PaginatedResponse, PaginationParams
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


@router.post(
    "/tokens/deactivate",
    response_model=TokenDeactivateResponse,
    dependencies=[InternalAuth],
)
async def deactivate_tokens(
    payload: TokenDeactivateRequest,
    db: DBSession,
) -> TokenDeactivateResponse:
    """Deactivate failed FCM tokens reported by the worker."""
    count = await service.deactivate_failed_tokens(db, payload.tokens)
    return TokenDeactivateResponse(deactivated_count=count)


@router.get(
    "/audit-logs",
    response_model=PaginatedResponse[AuditLogResponse],
    dependencies=[InternalAuth],
)
async def list_audit_logs(
    db: DBSession,
    page: int = Query(default=1, ge=1),
    limit: int = Query(default=50, ge=1, le=100),
) -> PaginatedResponse[AuditLogResponse]:
    """List audit log entries (paginated, newest first)."""
    params = PaginationParams(page=page, limit=limit)
    logs, total = await service.list_audit_logs(
        db, limit=params.limit, offset=params.offset
    )
    data = [AuditLogResponse.model_validate(lg) for lg in logs]
    return PaginatedResponse[AuditLogResponse].create(
        data=data,
        total=total,
        page=params.page,
        limit=params.limit,
    )


@router.get(
    "/export/{user_id}",
    dependencies=[InternalAuth],
)
async def export_user_data(
    user_id: UUID,
    db: DBSession,
) -> dict[str, Any]:
    """Export all data for a user (GDPR compliance)."""
    return await service.export_user_data(db, user_id)
