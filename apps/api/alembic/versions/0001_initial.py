"""initial schema

Revision ID: 0001
Revises:
Create Date: 2026-02-23 23:30:00.000000

"""

from collections.abc import Sequence

import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

from alembic import op

# revision identifiers, used by Alembic.
revision: str = "0001"
down_revision: str | None = None
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    # --- users ---
    op.create_table(
        "users",
        sa.Column(
            "id",
            sa.UUID(),
            server_default=sa.text("gen_random_uuid()"),
            nullable=False,
        ),
        sa.Column("email", sa.String(length=255), nullable=False),
        sa.Column("name", sa.String(length=255), nullable=True),
        sa.Column("image", sa.String(length=500), nullable=True),
        sa.Column(
            "email_verified",
            sa.Boolean(),
            server_default=sa.text("false"),
            nullable=False,
        ),
        sa.Column(
            "provider",
            sa.String(length=20),
            nullable=True,
            comment="OAuth provider: google | github | facebook",
        ),
        sa.Column(
            "provider_id",
            sa.String(length=255),
            nullable=True,
            comment="Provider-specific user ID",
        ),
        sa.Column(
            "role",
            sa.String(length=20),
            server_default="host",
            nullable=False,
        ),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.PrimaryKeyConstraint("id", name=op.f("pk_users")),
        sa.UniqueConstraint("email", name=op.f("uq_users_email")),
    )
    op.create_index(op.f("ix_users_email"), "users", ["email"], unique=True)
    op.create_index(op.f("ix_users_role"), "users", ["role"], unique=False)

    # --- care_relations ---
    op.create_table(
        "care_relations",
        sa.Column("host_id", sa.UUID(), nullable=False),
        sa.Column("caregiver_id", sa.UUID(), nullable=False),
        sa.Column(
            "role",
            sa.String(length=20),
            nullable=False,
            comment="Caregiver role: concierge | care_worker | organization",
        ),
        sa.Column("is_active", sa.Boolean(), nullable=False),
        sa.Column(
            "id",
            sa.UUID(),
            server_default=sa.text("gen_random_uuid()"),
            nullable=False,
        ),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=True),
        sa.CheckConstraint(
            "host_id != caregiver_id",
            name="no_self_relation",
        ),
        sa.ForeignKeyConstraint(
            ["caregiver_id"],
            ["users.id"],
            name=op.f("fk_care_relations_caregiver_id_users"),
            ondelete="CASCADE",
        ),
        sa.ForeignKeyConstraint(
            ["host_id"],
            ["users.id"],
            name=op.f("fk_care_relations_host_id_users"),
            ondelete="CASCADE",
        ),
        sa.PrimaryKeyConstraint("id", name=op.f("pk_care_relations")),
        sa.UniqueConstraint(
            "host_id",
            "caregiver_id",
            name="uq_care_relations_host_id_caregiver_id",
        ),
    )
    op.create_index(
        "ix_care_relations_caregiver_id",
        "care_relations",
        ["caregiver_id"],
        unique=False,
    )
    op.create_index(
        "ix_care_relations_host_id",
        "care_relations",
        ["host_id"],
        unique=False,
    )

    # --- wellness_logs ---
    op.create_table(
        "wellness_logs",
        sa.Column("host_id", sa.UUID(), nullable=False),
        sa.Column(
            "status",
            sa.String(length=20),
            nullable=False,
            comment="normal | warning | emergency",
        ),
        sa.Column(
            "summary",
            sa.Text(),
            nullable=False,
            comment="Human-readable summary of the wellness observation",
        ),
        sa.Column(
            "details",
            postgresql.JSONB(astext_type=sa.Text()),
            server_default=sa.text("'{}'::jsonb"),
            nullable=False,
        ),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.Column(
            "id",
            sa.UUID(),
            server_default=sa.text("gen_random_uuid()"),
            nullable=False,
        ),
        sa.ForeignKeyConstraint(
            ["host_id"],
            ["users.id"],
            name=op.f("fk_wellness_logs_host_id_users"),
            ondelete="CASCADE",
        ),
        sa.PrimaryKeyConstraint("id", name=op.f("pk_wellness_logs")),
    )
    op.create_index(
        "ix_wellness_logs_created_at",
        "wellness_logs",
        ["created_at"],
        unique=False,
    )
    op.create_index(
        "ix_wellness_logs_host_id",
        "wellness_logs",
        ["host_id"],
        unique=False,
    )

    # --- medications ---
    op.create_table(
        "medications",
        sa.Column("host_id", sa.UUID(), nullable=False),
        sa.Column("pill_name", sa.String(length=255), nullable=False),
        sa.Column("schedule_time", sa.DateTime(timezone=True), nullable=False),
        sa.Column("is_taken", sa.Boolean(), nullable=False),
        sa.Column("taken_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.Column(
            "id",
            sa.UUID(),
            server_default=sa.text("gen_random_uuid()"),
            nullable=False,
        ),
        sa.ForeignKeyConstraint(
            ["host_id"],
            ["users.id"],
            name=op.f("fk_medications_host_id_users"),
            ondelete="CASCADE",
        ),
        sa.PrimaryKeyConstraint("id", name=op.f("pk_medications")),
    )
    op.create_index(
        "ix_medications_host_id",
        "medications",
        ["host_id"],
        unique=False,
    )
    op.create_index(
        "ix_medications_schedule_time",
        "medications",
        ["schedule_time"],
        unique=False,
    )


def downgrade() -> None:
    op.drop_index("ix_medications_schedule_time", table_name="medications")
    op.drop_index("ix_medications_host_id", table_name="medications")
    op.drop_table("medications")
    op.drop_index("ix_wellness_logs_host_id", table_name="wellness_logs")
    op.drop_index("ix_wellness_logs_created_at", table_name="wellness_logs")
    op.drop_table("wellness_logs")
    op.drop_index("ix_care_relations_host_id", table_name="care_relations")
    op.drop_index("ix_care_relations_caregiver_id", table_name="care_relations")
    op.drop_table("care_relations")
    op.drop_index(op.f("ix_users_role"), table_name="users")
    op.drop_index(op.f("ix_users_email"), table_name="users")
    op.drop_table("users")
