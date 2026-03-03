"""Pydantic payload schemas for worker jobs."""

from pydantic import BaseModel, Field


class NotificationSendPayload(BaseModel):
    """Payload for notification.send job."""

    tokens: list[str]
    title: str = ""
    body: str = ""
    data: dict[str, str] = Field(default_factory=dict)


class WellnessEscalationPayload(BaseModel):
    """Payload for wellness.escalation job."""

    log_id: str = ""
    host_id: str = ""
    status: str = ""
    summary: str = ""
    contact_tokens: list[str] = Field(default_factory=list)


class MedicationReminderPayload(BaseModel):
    """Payload for medication.reminder job."""

    host_id: str = ""
    pill_name: str = "Unknown"
    tokens: list[str] = Field(default_factory=list)


class DataCleanupPayload(BaseModel):
    """Payload for data.cleanup job."""

    retention_days: int = 90
    resource_type: str = "all"


class RelationInactiveCheckPayload(BaseModel):
    """Payload for relation.inactive_check job."""

    threshold_days: int = 30


class WellnessAggregatePayload(BaseModel):
    """Payload for wellness.aggregate job."""

    host_id: str = Field(min_length=1)
    date: str = Field(min_length=1)
