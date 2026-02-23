import uuid
from datetime import datetime

from sqlalchemy import DateTime, ForeignKey, Index, String, func
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column

from src.common.models.base import UUIDMixin
from src.lib.database import Base


class Medication(Base, UUIDMixin):
    """Medication schedule entries for hosts."""

    __tablename__ = "medications"
    __table_args__ = (
        Index("ix_medications_host_id", "host_id"),
        Index("ix_medications_schedule_time", "schedule_time"),
    )

    host_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
    )
    pill_name: Mapped[str] = mapped_column(
        String(255),
        nullable=False,
    )
    schedule_time: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
    )
    is_taken: Mapped[bool] = mapped_column(
        default=False,
        nullable=False,
    )
    taken_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True),
        nullable=True,
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
    )
