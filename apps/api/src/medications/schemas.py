import uuid
from datetime import datetime

from pydantic import BaseModel, Field


class MedicationCreate(BaseModel):
    """Request body for creating a medication schedule."""

    host_id: uuid.UUID
    pill_name: str = Field(..., min_length=1, max_length=255)
    schedule_time: datetime


class MedicationResponse(BaseModel):
    """Response model for a medication entry."""

    id: uuid.UUID
    host_id: uuid.UUID
    pill_name: str
    schedule_time: datetime
    is_taken: bool
    taken_at: datetime | None = None
    created_at: datetime

    model_config = {"from_attributes": True}


class MedicationUpdate(BaseModel):
    """Request body for updating a medication."""

    pill_name: str | None = Field(default=None, min_length=1, max_length=255)
    schedule_time: datetime | None = None
    is_taken: bool | None = None


class MedicationAdherenceResponse(BaseModel):
    """Medication adherence statistics."""

    host_id: uuid.UUID
    date_from: str
    date_to: str
    total: int
    taken: int
    missed: int
    adherence_rate: float
