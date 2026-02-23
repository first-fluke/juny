import uuid
from datetime import datetime
from typing import Any

from pydantic import BaseModel, Field

from src.common.enums import WellnessStatus


class WellnessLogCreate(BaseModel):
    """Request body for creating a wellness log."""

    host_id: uuid.UUID
    status: WellnessStatus
    summary: str = Field(..., min_length=1, max_length=2000)
    details: dict[str, Any] = Field(default_factory=dict)


class WellnessLogResponse(BaseModel):
    """Response model for a wellness log."""

    id: uuid.UUID
    host_id: uuid.UUID
    status: str
    summary: str
    details: dict[str, Any]
    created_at: datetime

    model_config = {"from_attributes": True}
