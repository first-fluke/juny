import uuid
from datetime import datetime
from typing import Any

from sqlalchemy import DateTime, ForeignKey, Index, String, Text, func, text
from sqlalchemy.dialects.postgresql import JSONB, UUID
from sqlalchemy.orm import Mapped, mapped_column

from src.common.models.base import UUIDMixin
from src.lib.database import Base


class WellnessLog(Base, UUIDMixin):
    """Append-only wellness log entries created by AI or caregivers."""

    __tablename__ = "wellness_logs"
    __table_args__ = (
        Index("ix_wellness_logs_host_id", "host_id"),
        Index("ix_wellness_logs_created_at", "created_at"),
    )

    host_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
    )
    status: Mapped[str] = mapped_column(
        String(20),
        nullable=False,
        comment="normal | warning | emergency",
    )
    summary: Mapped[str] = mapped_column(
        Text,
        nullable=False,
        comment="Human-readable summary of the wellness observation",
    )
    details: Mapped[dict[str, Any]] = mapped_column(
        JSONB,
        nullable=False,
        default=dict,
        server_default=text("'{}'::jsonb"),
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
    )
