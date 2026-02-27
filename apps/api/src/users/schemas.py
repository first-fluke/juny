"""Pydantic schemas for the users module."""

import uuid
from datetime import datetime

from pydantic import BaseModel

from src.common.enums import UserRole


class UserResponse(BaseModel):
    """Public user representation."""

    model_config = {"from_attributes": True}

    id: uuid.UUID
    email: str
    name: str | None = None
    image: str | None = None
    email_verified: bool = False
    provider: str | None = None
    provider_id: str | None = None
    role: str = UserRole.HOST.value
    created_at: datetime
    updated_at: datetime


class UserUpdate(BaseModel):
    """Payload for self-service profile update."""

    name: str | None = None
    image: str | None = None


class UserRoleUpdate(BaseModel):
    """Payload for admin role change."""

    role: str
