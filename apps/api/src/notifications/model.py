"""DeviceToken model for push notification delivery."""

import uuid

from sqlalchemy import ForeignKey, Index, String
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column

from src.common.models.base import TimestampMixin, UUIDMixin
from src.lib.database import Base


class DeviceToken(Base, UUIDMixin, TimestampMixin):
    """FCM device token registered by a user."""

    __tablename__ = "device_tokens"
    __table_args__ = (Index("ix_device_tokens_user_id", "user_id"),)

    user_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
    )
    token: Mapped[str] = mapped_column(
        String(512),
        unique=True,
        index=True,
        nullable=False,
    )
    platform: Mapped[str] = mapped_column(
        String(10),
        nullable=False,
        comment="ios | android | web",
    )
    is_active: Mapped[bool] = mapped_column(
        default=True,
        nullable=False,
    )
