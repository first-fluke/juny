"""HTTP endpoints for notification logs and preferences."""

import uuid

from fastapi import APIRouter, Query, status

from src.common.errors import RES_003, raise_api_error
from src.common.models import PaginatedResponse, PaginationParams
from src.lib.dependencies import CurrentUser, DBSession
from src.lib.internal_auth import InternalAuth
from src.notification_logs import service
from src.notification_logs.schemas import (
    NotificationLogResponse,
    NotificationLogStatusUpdate,
    NotificationPreferenceResponse,
    NotificationPreferenceUpdate,
)

router = APIRouter()


@router.get(
    "",
    response_model=PaginatedResponse[NotificationLogResponse],
)
async def list_notification_logs(
    db: DBSession,
    user: CurrentUser,
    page: int = Query(default=1, ge=1),
    limit: int = Query(default=20, ge=1, le=100),
) -> PaginatedResponse[NotificationLogResponse]:
    """List notification logs for the current user (own notifications only)."""
    params = PaginationParams(page=page, limit=limit)
    logs, total = await service.list_logs(
        db, uuid.UUID(user.id), limit=params.limit, offset=params.offset
    )
    data = [NotificationLogResponse.model_validate(lg) for lg in logs]
    return PaginatedResponse[NotificationLogResponse].create(
        data=data,
        total=total,
        page=params.page,
        limit=params.limit,
    )


@router.get(
    "/preferences",
    response_model=NotificationPreferenceResponse,
)
async def get_preferences(
    db: DBSession,
    user: CurrentUser,
) -> NotificationPreferenceResponse:
    """Get notification preferences for the current user."""
    pref = await service.get_preferences(db, uuid.UUID(user.id))
    return NotificationPreferenceResponse.model_validate(pref)


@router.put(
    "/preferences",
    response_model=NotificationPreferenceResponse,
)
async def update_preferences(
    payload: NotificationPreferenceUpdate,
    db: DBSession,
    user: CurrentUser,
) -> NotificationPreferenceResponse:
    """Update notification preferences for the current user."""
    pref = await service.update_preferences(db, uuid.UUID(user.id), payload)
    return NotificationPreferenceResponse.model_validate(pref)


@router.patch(
    "/{log_id}/status",
    response_model=NotificationLogResponse,
    dependencies=[InternalAuth],
)
async def update_log_status(
    log_id: uuid.UUID,
    payload: NotificationLogStatusUpdate,
    db: DBSession,
) -> NotificationLogResponse:
    """Update notification log delivery status (internal/worker callback)."""
    log = await service.get_log(db, log_id)
    if not log:
        raise_api_error(RES_003, status.HTTP_404_NOT_FOUND)
    updated = await service.update_log_status(db, log, payload.status)
    return NotificationLogResponse.model_validate(updated)
