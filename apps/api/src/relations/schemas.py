import uuid
from datetime import datetime

from pydantic import BaseModel, Field

from src.common.enums import UserRole


class CareRelationCreate(BaseModel):
    """Request body for creating a care relation."""

    host_id: uuid.UUID
    caregiver_id: uuid.UUID
    role: str = Field(
        ...,
        description="Caregiver role",
        examples=["concierge", "care_worker", "organization"],
    )


class CareRelationResponse(BaseModel):
    """Response model for a care relation."""

    id: uuid.UUID
    host_id: uuid.UUID
    caregiver_id: uuid.UUID
    role: str
    is_active: bool
    created_at: datetime
    updated_at: datetime | None = None

    model_config = {"from_attributes": True}


class CareRelationUpdate(BaseModel):
    """Request body for updating a care relation."""

    is_active: bool | None = None
    role: str | None = None


# Allowed caregiver roles (HOST cannot be a caregiver role)
CAREGIVER_ROLES = {
    UserRole.CONCIERGE.value,
    UserRole.CARE_WORKER.value,
    UserRole.ORGANIZATION.value,
}
