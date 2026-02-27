"""Admin endpoint request/response schemas."""

import uuid
from datetime import datetime

from pydantic import BaseModel


class CleanupRequest(BaseModel):
    retention_days: int = 90
    resource_type: str = "all"  # "all" | "wellness_logs" | "device_tokens"


class CleanupResponse(BaseModel):
    deleted_wellness_logs: int
    deactivated_tokens: int


class InactiveRelationResponse(BaseModel):
    relation_id: uuid.UUID
    host_id: uuid.UUID
    caregiver_id: uuid.UUID
    role: str
    last_wellness_at: datetime | None
    inactive_days: int


class WellnessAggregateResponse(BaseModel):
    host_id: uuid.UUID
    date: str
    total_logs: int
    by_status: dict[str, int]
