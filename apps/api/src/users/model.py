import uuid as uuid_lib
from datetime import datetime

from sqlalchemy import DateTime, String, func, text
from sqlalchemy.orm import Mapped, mapped_column

from src.common.enums import UserRole
from src.lib.database import Base


class User(Base):
    """User model for authentication."""

    __tablename__ = "users"

    id: Mapped[uuid_lib.UUID] = mapped_column(
        primary_key=True,
        default=uuid_lib.uuid4,
        server_default=text("gen_random_uuid()"),
    )
    email: Mapped[str] = mapped_column(String(255), unique=True, index=True)
    name: Mapped[str | None] = mapped_column(String(255), nullable=True)
    image: Mapped[str | None] = mapped_column(String(500), nullable=True)
    email_verified: Mapped[bool] = mapped_column(default=False)
    provider: Mapped[str | None] = mapped_column(
        String(20), nullable=True, comment="OAuth provider: google | github | facebook"
    )
    provider_id: Mapped[str | None] = mapped_column(
        String(255), nullable=True, comment="Provider-specific user ID"
    )
    role: Mapped[str] = mapped_column(
        String(20),
        nullable=False,
        default=UserRole.HOST.value,
        server_default=UserRole.HOST.value,
        index=True,
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
    )
