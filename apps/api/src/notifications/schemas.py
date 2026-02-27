"""Pydantic schemas for the notifications module."""

import uuid
from datetime import datetime
from typing import Literal

from pydantic import BaseModel


class DeviceTokenCreate(BaseModel):
    """Payload for registering a device token."""

    token: str
    platform: Literal["ios", "android", "web"]


class DeviceTokenResponse(BaseModel):
    """Public device token representation."""

    model_config = {"from_attributes": True}

    id: uuid.UUID
    user_id: uuid.UUID
    token: str
    platform: str
    is_active: bool
    created_at: datetime
