import uuid
from datetime import date

from fastapi import APIRouter, Query, status

from src.common.errors import RES_003, raise_api_error
from src.common.models import PaginatedResponse, PaginationParams
from src.lib.authorization import authorize_host_access
from src.lib.dependencies import CurrentUser, DBSession
from src.medications import service
from src.medications.schemas import (
    MedicationAdherenceResponse,
    MedicationCreate,
    MedicationResponse,
    MedicationUpdate,
)

router = APIRouter()


@router.post(
    "",
    response_model=MedicationResponse,
    status_code=status.HTTP_201_CREATED,
)
async def create_medication(
    payload: MedicationCreate,
    db: DBSession,
    user: CurrentUser,
) -> MedicationResponse:
    """Create a medication schedule entry for a host."""
    await authorize_host_access(db, user=user, host_id=payload.host_id)
    medication = await service.create_medication(db, payload)
    return MedicationResponse.model_validate(medication)


@router.get(
    "",
    response_model=PaginatedResponse[MedicationResponse],
)
async def list_medications(
    db: DBSession,
    user: CurrentUser,
    host_id: uuid.UUID = Query(...),
    page: int = Query(default=1, ge=1),
    limit: int = Query(default=20, ge=1, le=100),
) -> PaginatedResponse[MedicationResponse]:
    """List medications for a host (paginated, newest first)."""
    await authorize_host_access(db, user=user, host_id=host_id)
    params = PaginationParams(page=page, limit=limit)
    meds, total = await service.list_medications(
        db, host_id, limit=params.limit, offset=params.offset
    )
    data = [MedicationResponse.model_validate(m) for m in meds]
    return PaginatedResponse[MedicationResponse].create(
        data=data,
        total=total,
        page=params.page,
        limit=params.limit,
    )


@router.get("/adherence", response_model=MedicationAdherenceResponse)
async def get_medication_adherence(
    db: DBSession,
    user: CurrentUser,
    host_id: uuid.UUID = Query(...),
    date_from: date = Query(...),
    date_to: date = Query(...),
) -> MedicationAdherenceResponse:
    """Get medication adherence statistics for a host within a date range."""
    await authorize_host_access(db, user=user, host_id=host_id)
    return await service.get_adherence_stats(db, host_id, date_from, date_to)


@router.get("/{medication_id}", response_model=MedicationResponse)
async def get_medication(
    medication_id: uuid.UUID,
    db: DBSession,
    user: CurrentUser,
) -> MedicationResponse:
    """Get a specific medication by ID."""
    medication = await service.get_medication(db, medication_id)
    if not medication:
        raise_api_error(RES_003, status.HTTP_404_NOT_FOUND)
    await authorize_host_access(db, user=user, host_id=medication.host_id)
    return MedicationResponse.model_validate(medication)


@router.patch(
    "/{medication_id}",
    response_model=MedicationResponse,
)
async def update_medication(
    medication_id: uuid.UUID,
    payload: MedicationUpdate,
    db: DBSession,
    user: CurrentUser,
) -> MedicationResponse:
    """Update a medication entry (e.g. mark as taken)."""
    medication = await service.get_medication(db, medication_id)
    if not medication:
        raise_api_error(RES_003, status.HTTP_404_NOT_FOUND)
    await authorize_host_access(db, user=user, host_id=medication.host_id)
    updated = await service.update_medication(db, medication, payload)
    return MedicationResponse.model_validate(updated)


@router.delete(
    "/{medication_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def delete_medication(
    medication_id: uuid.UUID,
    db: DBSession,
    user: CurrentUser,
) -> None:
    """Delete a medication entry."""
    medication = await service.get_medication(db, medication_id)
    if not medication:
        raise_api_error(RES_003, status.HTTP_404_NOT_FOUND)
    await authorize_host_access(db, user=user, host_id=medication.host_id)
    await service.delete_medication(db, medication)
