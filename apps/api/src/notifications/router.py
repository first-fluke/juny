"""Device token management endpoints."""

import uuid

from fastapi import APIRouter, status

from src.common.errors import RES_005, raise_api_error
from src.lib.dependencies import CurrentUser, DBSession
from src.notifications import service
from src.notifications.schemas import DeviceTokenCreate, DeviceTokenResponse

router = APIRouter()


@router.post(
    "/device-tokens",
    response_model=DeviceTokenResponse,
    status_code=status.HTTP_201_CREATED,
)
async def register_device_token(
    payload: DeviceTokenCreate,
    user: CurrentUser,
    db: DBSession,
) -> DeviceTokenResponse:
    """Register a device token for push notifications."""
    token = await service.register_token(db, uuid.UUID(user.id), payload)
    return DeviceTokenResponse.model_validate(token)


@router.get(
    "/device-tokens",
    response_model=list[DeviceTokenResponse],
)
async def list_device_tokens(
    user: CurrentUser,
    db: DBSession,
) -> list[DeviceTokenResponse]:
    """List the current user's active device tokens."""
    tokens = await service.get_user_tokens(db, uuid.UUID(user.id))
    return [DeviceTokenResponse.model_validate(t) for t in tokens]


@router.delete(
    "/device-tokens/{token_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def unregister_device_token(
    token_id: uuid.UUID,
    user: CurrentUser,
    db: DBSession,
) -> None:
    """Deactivate a device token."""
    result = await service.unregister_token(db, token_id, uuid.UUID(user.id))
    if result is None:
        raise_api_error(RES_005, status.HTTP_404_NOT_FOUND)
