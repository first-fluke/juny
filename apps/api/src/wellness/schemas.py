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


class DailyWellnessStat(BaseModel):
    """Daily aggregated wellness statistics."""

    date: str
    normal: int = 0
    warning: int = 0
    emergency: int = 0


class WellnessTrendResponse(BaseModel):
    """Response model for wellness trend analysis."""

    host_id: uuid.UUID
    date_from: str
    date_to: str
    daily_stats: list[DailyWellnessStat]
