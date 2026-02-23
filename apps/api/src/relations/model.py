import uuid

from sqlalchemy import CheckConstraint, ForeignKey, Index, String, UniqueConstraint
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column

from src.common.models.base import TimestampMixin, UUIDMixin
from src.lib.database import Base


class CareRelation(Base, UUIDMixin, TimestampMixin):
    """N:M care relationship between host and caregiver users.

    Supports B2B/B2G: one org/family can manage multiple hosts,
    and one host can have multiple caregivers.
    """

    __tablename__ = "care_relations"
    __table_args__ = (
        UniqueConstraint(
            "host_id",
            "caregiver_id",
            name="uq_care_relations_host_id_caregiver_id",
        ),
        CheckConstraint(
            "host_id != caregiver_id",
            name="no_self_relation",
        ),
        Index("ix_care_relations_host_id", "host_id"),
        Index("ix_care_relations_caregiver_id", "caregiver_id"),
    )

    host_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
    )
    caregiver_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
    )
    role: Mapped[str] = mapped_column(
        String(20),
        nullable=False,
        comment="Caregiver role: concierge | care_worker | organization",
    )
    is_active: Mapped[bool] = mapped_column(
        default=True,
        nullable=False,
    )
