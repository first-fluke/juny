"""Admin domain models."""

import uuid
from datetime import datetime
from typing import Any

from sqlalchemy import DateTime, Index, String, Text, func, text
from sqlalchemy.dialects.postgresql import JSONB, UUID
from sqlalchemy.orm import Mapped, mapped_column

from src.common.models.base import UUIDMixin
from src.lib.database import Base


class AuditLog(Base, UUIDMixin):
    """Immutable record of administrative actions."""

    __tablename__ = "audit_logs"
    __table_args__ = (
        Index("ix_audit_logs_actor_id", "actor_id"),
        Index("ix_audit_logs_timestamp", "timestamp"),
    )

    actor_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True),
        nullable=True,
        comment="User or service that performed the action",
    )
    action: Mapped[str] = mapped_column(
        String(100),
        nullable=False,
        comment="e.g. cleanup, deactivate_tokens",
    )
    resource_type: Mapped[str] = mapped_column(
        String(100),
        nullable=False,
        comment="e.g. wellness_logs, device_tokens",
    )
    detail: Mapped[dict[str, Any]] = mapped_column(
        JSONB,
        nullable=False,
        default=dict,
        server_default=text("'{}'::jsonb"),
    )
    description: Mapped[str | None] = mapped_column(
        Text,
        nullable=True,
    )
    timestamp: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
    )
