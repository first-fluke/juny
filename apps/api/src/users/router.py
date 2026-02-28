"""HTTP endpoints for users."""

import uuid
from typing import Any

from fastapi import APIRouter, HTTPException, Query, status

from src.admin import service as admin_service
from src.common.enums import UserRole
from src.common.errors import RES_004, raise_api_error
from src.common.models import PaginatedResponse, PaginationParams
from src.lib.authorization import authorize_host_access, require_role
from src.lib.dependencies import CurrentUser, DBSession, StorageDep
from src.users import service
from src.users.schemas import UserResponse, UserRoleUpdate, UserUpdate

router = APIRouter()

_ORG_ROLES = {UserRole.ORGANIZATION.value}


@router.get("/me", response_model=UserResponse)
async def get_my_profile(
    db: DBSession,
    user: CurrentUser,
) -> UserResponse:
    """Get the current user's profile."""
    db_user = await service.get_user(db, uuid.UUID(user.id))
    if not db_user:
        raise_api_error(RES_004, status.HTTP_404_NOT_FOUND)
    return UserResponse.model_validate(db_user)


@router.patch("/me", response_model=UserResponse)
async def update_my_profile(
    payload: UserUpdate,
    db: DBSession,
    user: CurrentUser,
) -> UserResponse:
    """Update the current user's profile (name, image)."""
    db_user = await service.get_user(db, uuid.UUID(user.id))
    if not db_user:
        raise_api_error(RES_004, status.HTTP_404_NOT_FOUND)
    updated = await service.update_user(db, db_user, payload)
    return UserResponse.model_validate(updated)


@router.delete("/me", status_code=status.HTTP_204_NO_CONTENT)
async def delete_me(
    db: DBSession,
    user: CurrentUser,
    storage: StorageDep,
) -> None:
    """Delete the current user's own account."""
    await service.delete_own_account(db, uuid.UUID(user.id), storage)


@router.get("/me/export")
async def export_my_data(
    db: DBSession,
    user: CurrentUser,
) -> dict[str, Any]:
    """Export all personal data (GDPR self-service)."""
    return await admin_service.export_user_data(db, uuid.UUID(user.id))


@router.get("", response_model=PaginatedResponse[UserResponse])
async def list_users(
    db: DBSession,
    user: CurrentUser,
    page: int = Query(default=1, ge=1),
    limit: int = Query(default=20, ge=1, le=100),
) -> PaginatedResponse[UserResponse]:
    """List all users (ORGANIZATION role only)."""
    require_role(user, allowed_roles=_ORG_ROLES)
    params = PaginationParams(page=page, limit=limit)
    users, total = await service.list_users(
        db, limit=params.limit, offset=params.offset
    )
    data = [UserResponse.model_validate(u) for u in users]
    return PaginatedResponse[UserResponse].create(
        data=data,
        total=total,
        page=params.page,
        limit=params.limit,
    )


@router.get("/{user_id}", response_model=UserResponse)
async def get_user(
    user_id: uuid.UUID,
    db: DBSession,
    user: CurrentUser,
) -> UserResponse:
    """Get a user by ID.

    Access: self, active CareRelation, or ORGANIZATION.
    """
    if user.role == UserRole.ORGANIZATION.value or str(user_id) == user.id:
        pass
    else:
        await authorize_host_access(db, user=user, host_id=user_id)

    db_user = await service.get_user(db, user_id)
    if not db_user:
        raise_api_error(RES_004, status.HTTP_404_NOT_FOUND)
    return UserResponse.model_validate(db_user)


@router.patch("/{user_id}/role", response_model=UserResponse)
async def update_user_role(
    user_id: uuid.UUID,
    payload: UserRoleUpdate,
    db: DBSession,
    user: CurrentUser,
) -> UserResponse:
    """Change a user's role (ORGANIZATION only)."""
    require_role(user, allowed_roles=_ORG_ROLES)
    db_user = await service.get_user(db, user_id)
    if not db_user:
        raise_api_error(RES_004, status.HTTP_404_NOT_FOUND)
    try:
        updated = await service.update_user_role(db, db_user, payload)
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_CONTENT,
            detail=str(e),
        ) from e
    return UserResponse.model_validate(updated)


@router.delete("/{user_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_user(
    user_id: uuid.UUID,
    db: DBSession,
    user: CurrentUser,
) -> None:
    """Delete a user (ORGANIZATION only)."""
    require_role(user, allowed_roles=_ORG_ROLES)
    db_user = await service.get_user(db, user_id)
    if not db_user:
        raise_api_error(RES_004, status.HTTP_404_NOT_FOUND)
    await service.delete_user(db, db_user)
