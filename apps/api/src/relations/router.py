import uuid

from fastapi import APIRouter, HTTPException, Query, status

from src.common.errors import AUTHZ_001, RES_001, raise_api_error
from src.lib.authorization import authorize_relation_access
from src.lib.dependencies import CurrentUser, DBSession
from src.relations import service
from src.relations.schemas import (
    CareRelationCreate,
    CareRelationResponse,
    CareRelationUpdate,
)

router = APIRouter()


@router.post(
    "",
    response_model=CareRelationResponse,
    status_code=status.HTTP_201_CREATED,
)
async def create_care_relation(
    payload: CareRelationCreate,
    db: DBSession,
    user: CurrentUser,
) -> CareRelationResponse:
    """Create a new care relation between host and caregiver.

    Only the host or an existing caregiver of the host may create new relations.
    """
    user_uuid = uuid.UUID(user.id)
    if user_uuid not in (payload.host_id, payload.caregiver_id):
        raise_api_error(AUTHZ_001, status.HTTP_403_FORBIDDEN)
    try:
        relation = await service.create_relation(db, payload)
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_CONTENT,
            detail=str(e),
        ) from e
    return CareRelationResponse.model_validate(relation)


@router.get("", response_model=list[CareRelationResponse])
async def list_care_relations(
    db: DBSession,
    user: CurrentUser,
    host_id: uuid.UUID | None = Query(default=None),
    caregiver_id: uuid.UUID | None = Query(default=None),
    active_only: bool = Query(default=True),
) -> list[CareRelationResponse]:
    """List care relations filtered by host or caregiver.

    Users can only list relations they participate in.
    """
    user_uuid = uuid.UUID(user.id)

    if host_id:
        if user_uuid != host_id:
            # Verify caller is a caregiver for this host
            relations = await service.list_relations_for_host(
                db, host_id, active_only=active_only
            )
            if not any(r.caregiver_id == user_uuid for r in relations):
                raise_api_error(AUTHZ_001, status.HTTP_403_FORBIDDEN)
            return [CareRelationResponse.model_validate(r) for r in relations]
        relations = await service.list_relations_for_host(
            db, host_id, active_only=active_only
        )
    elif caregiver_id:
        if user_uuid != caregiver_id:
            raise_api_error(AUTHZ_001, status.HTTP_403_FORBIDDEN)
        relations = await service.list_relations_for_caregiver(
            db, caregiver_id, active_only=active_only
        )
    else:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Either host_id or caregiver_id is required",
        )
    return [CareRelationResponse.model_validate(r) for r in relations]


@router.get("/{relation_id}", response_model=CareRelationResponse)
async def get_care_relation(
    relation_id: uuid.UUID,
    db: DBSession,
    user: CurrentUser,
) -> CareRelationResponse:
    """Get a specific care relation by ID."""
    relation = await service.get_relation(db, relation_id)
    if not relation:
        raise_api_error(RES_001, status.HTTP_404_NOT_FOUND)
    await authorize_relation_access(db, user=user, relation=relation)
    return CareRelationResponse.model_validate(relation)


@router.patch(
    "/{relation_id}",
    response_model=CareRelationResponse,
)
async def update_care_relation(
    relation_id: uuid.UUID,
    payload: CareRelationUpdate,
    db: DBSession,
    user: CurrentUser,
) -> CareRelationResponse:
    """Update a care relation (e.g. deactivate, change role)."""
    relation = await service.get_relation(db, relation_id)
    if not relation:
        raise_api_error(RES_001, status.HTTP_404_NOT_FOUND)
    await authorize_relation_access(db, user=user, relation=relation)
    try:
        updated = await service.update_relation(db, relation, payload)
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_CONTENT,
            detail=str(e),
        ) from e
    return CareRelationResponse.model_validate(updated)


@router.delete(
    "/{relation_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def delete_care_relation(
    relation_id: uuid.UUID,
    db: DBSession,
    user: CurrentUser,
) -> None:
    """Delete a care relation."""
    relation = await service.get_relation(db, relation_id)
    if not relation:
        raise_api_error(RES_001, status.HTTP_404_NOT_FOUND)
    await authorize_relation_access(db, user=user, relation=relation)
    await service.delete_relation(db, relation)
