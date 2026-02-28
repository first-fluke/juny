"""Notification log and preference models."""

import uuid
from datetime import datetime
from typing import Any

from sqlalchemy import DateTime, ForeignKey, Index, String, Text, func, text
from sqlalchemy.dialects.postgresql import JSONB, UUID
from sqlalchemy.orm import Mapped, mapped_column

from src.common.models.base import TimestampMixin, UUIDMixin
from src.lib.database import Base


class NotificationLog(Base, UUIDMixin):
    """Immutable record of a notification sent to a user."""

    __tablename__ = "notification_logs"
    __table_args__ = (
        Index("ix_notification_logs_recipient_id", "recipient_id"),
        Index("ix_notification_logs_created_at", "created_at"),
    )

    recipient_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
    )
    title: Mapped[str] = mapped_column(
        String(255),
        nullable=False,
    )
    body: Mapped[str] = mapped_column(
        Text,
        nullable=False,
    )
    status: Mapped[str] = mapped_column(
        String(20),
        nullable=False,
        server_default="pending",
        comment="pending | sent | failed",
    )
    channel: Mapped[str] = mapped_column(
        String(20),
        nullable=False,
        server_default="push",
        comment="push",
    )
    metadata_: Mapped[dict[str, Any]] = mapped_column(
        "metadata",
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


class NotificationPreference(Base, UUIDMixin, TimestampMixin):
    """Per-user notification preference settings."""

    __tablename__ = "notification_preferences"

    user_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        unique=True,
        nullable=False,
    )
    wellness_alerts: Mapped[bool] = mapped_column(
        default=True,
        server_default=text("true"),
        nullable=False,
    )
    medication_reminders: Mapped[bool] = mapped_column(
        default=True,
        server_default=text("true"),
        nullable=False,
    )
    system_updates: Mapped[bool] = mapped_column(
        default=True,
        server_default=text("true"),
        nullable=False,
    )
