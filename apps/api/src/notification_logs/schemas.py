"""Pydantic schemas for notification logs and preferences."""

import uuid
from datetime import datetime
from typing import Any

from pydantic import BaseModel


class NotificationLogResponse(BaseModel):
    """Read-only representation of a notification log entry."""

    id: uuid.UUID
    recipient_id: uuid.UUID
    title: str
    body: str
    status: str
    channel: str
    metadata: dict[str, Any] = {}
    created_at: datetime

    model_config = {"from_attributes": True}


class NotificationLogStatusUpdate(BaseModel):
    """Payload for updating a notification log's delivery status."""

    status: str


class NotificationPreferenceResponse(BaseModel):
    """Read-only representation of notification preferences."""

    user_id: uuid.UUID
    wellness_alerts: bool
    medication_reminders: bool
    system_updates: bool

    model_config = {"from_attributes": True}


class NotificationPreferenceUpdate(BaseModel):
    """Payload for updating notification preferences."""

    wellness_alerts: bool | None = None
    medication_reminders: bool | None = None
    system_updates: bool | None = None
