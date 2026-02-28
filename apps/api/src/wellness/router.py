import uuid
from datetime import date

from fastapi import APIRouter, Query, status

from src.common.errors import RES_002, raise_api_error
from src.common.models import PaginatedResponse, PaginationParams
from src.lib.authorization import authorize_host_access
from src.lib.dependencies import CurrentUser, DBSession
from src.wellness import service
from src.wellness.schemas import (
    WellnessLogCreate,
    WellnessLogResponse,
    WellnessTrendResponse,
)

router = APIRouter()


@router.post(
    "",
    response_model=WellnessLogResponse,
    status_code=status.HTTP_201_CREATED,
)
async def create_wellness_log(
    payload: WellnessLogCreate,
    db: DBSession,
    user: CurrentUser,
) -> WellnessLogResponse:
    """Create a wellness log entry for a host."""
    await authorize_host_access(db, user=user, host_id=payload.host_id)
    log_entry = await service.create_wellness_log(db, payload)
    return WellnessLogResponse.model_validate(log_entry)


@router.get(
    "",
    response_model=PaginatedResponse[WellnessLogResponse],
)
async def list_wellness_logs(
    db: DBSession,
    user: CurrentUser,
    host_id: uuid.UUID = Query(...),
    page: int = Query(default=1, ge=1),
    limit: int = Query(default=20, ge=1, le=100),
) -> PaginatedResponse[WellnessLogResponse]:
    """List wellness logs for a host (paginated, newest first)."""
    await authorize_host_access(db, user=user, host_id=host_id)
    params = PaginationParams(page=page, limit=limit)
    logs, total = await service.list_wellness_logs(
        db, host_id, limit=params.limit, offset=params.offset
    )
    data = [WellnessLogResponse.model_validate(entry) for entry in logs]
    return PaginatedResponse[WellnessLogResponse].create(
        data=data,
        total=total,
        page=params.page,
        limit=params.limit,
    )


@router.get(
    "/trends",
    response_model=WellnessTrendResponse,
)
async def get_wellness_trend(
    db: DBSession,
    user: CurrentUser,
    host_id: uuid.UUID = Query(...),
    date_from: date = Query(...),
    date_to: date = Query(...),
) -> WellnessTrendResponse:
    """Get wellness trend analysis for a host within a date range."""
    await authorize_host_access(db, user=user, host_id=host_id)
    return await service.get_wellness_trend(db, host_id, date_from, date_to)


@router.get(
    "/{log_id}",
    response_model=WellnessLogResponse,
)
async def get_wellness_log(
    log_id: uuid.UUID,
    db: DBSession,
    user: CurrentUser,
) -> WellnessLogResponse:
    """Get a specific wellness log by ID."""
    log_entry = await service.get_wellness_log(db, log_id)
    if not log_entry:
        raise_api_error(RES_002, status.HTTP_404_NOT_FOUND)
    await authorize_host_access(db, user=user, host_id=log_entry.host_id)
    return WellnessLogResponse.model_validate(log_entry)
