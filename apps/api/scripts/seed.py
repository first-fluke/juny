"""Demo seed script for hackathon.

Inserts deterministic demo data (Host, Concierge, CareRelation,
WellnessLogs, Medications).  Re-runnable: deletes previous demo
rows by their fixed UUIDs before inserting.

Usage:
    cd apps/api && uv run python scripts/seed.py
"""

import asyncio
import uuid
from datetime import UTC, datetime, timedelta

from sqlalchemy import delete
from sqlalchemy.ext.asyncio import AsyncSession

from src.common.enums import UserRole, WellnessStatus
from src.lib.database import async_session_factory
from src.lib.logging import configure_logging, get_logger
from src.medications.model import Medication
from src.relations.model import CareRelation
from src.users.model import User
from src.wellness.model import WellnessLog

configure_logging()
logger = get_logger(__name__)

# ── Deterministic UUIDs for demo data ────────────────────────────
HOST_ID = uuid.UUID("00000000-0000-4000-8000-000000000100")
CONCIERGE_ID = uuid.UUID("00000000-0000-4000-8000-000000000101")
RELATION_ID = uuid.UUID("00000000-0000-4000-8000-000000000200")
WELLNESS_IDS = [
    uuid.UUID("00000000-0000-4000-8000-000000000300"),
    uuid.UUID("00000000-0000-4000-8000-000000000301"),
    uuid.UUID("00000000-0000-4000-8000-000000000302"),
]
MEDICATION_IDS = [
    uuid.UUID("00000000-0000-4000-8000-000000000400"),
    uuid.UUID("00000000-0000-4000-8000-000000000401"),
]

ALL_USER_IDS = [HOST_ID, CONCIERGE_ID]
ALL_RELATION_IDS = [RELATION_ID]
ALL_WELLNESS_IDS = WELLNESS_IDS
ALL_MEDICATION_IDS = MEDICATION_IDS


async def _clear_demo_data(db: AsyncSession) -> None:
    """Delete previous demo rows by their fixed UUIDs."""
    await db.execute(delete(Medication).where(Medication.id.in_(ALL_MEDICATION_IDS)))
    await db.execute(delete(WellnessLog).where(WellnessLog.id.in_(ALL_WELLNESS_IDS)))
    await db.execute(delete(CareRelation).where(CareRelation.id.in_(ALL_RELATION_IDS)))
    await db.execute(delete(User).where(User.id.in_(ALL_USER_IDS)))
    await db.flush()
    logger.info("seed_cleared_previous_demo_data")


async def _insert_demo_data(db: AsyncSession) -> None:
    """Insert demo users, relations, wellness logs, and medications."""
    now = datetime.now(UTC)

    # ── Users ─────────────────────────────────────────────────────
    host = User(
        id=HOST_ID,
        email="grandma.kim@demo.juny.app",
        name="김할머니",
        email_verified=True,
        provider="google",
        provider_id="demo-host-001",
        role=UserRole.HOST.value,
    )
    concierge = User(
        id=CONCIERGE_ID,
        email="son.kim@demo.juny.app",
        name="김아들",
        email_verified=True,
        provider="google",
        provider_id="demo-concierge-001",
        role=UserRole.CONCIERGE.value,
    )
    db.add_all([host, concierge])
    await db.flush()
    logger.info("seed_users_created", host=host.name, concierge=concierge.name)

    # ── CareRelation ──────────────────────────────────────────────
    relation = CareRelation(
        id=RELATION_ID,
        host_id=HOST_ID,
        caregiver_id=CONCIERGE_ID,
        role=UserRole.CONCIERGE.value,
        is_active=True,
    )
    db.add(relation)
    await db.flush()
    logger.info("seed_care_relation_created")

    # ── WellnessLogs (3 entries) ──────────────────────────────────
    wellness_entries = [
        WellnessLog(
            id=WELLNESS_IDS[0],
            host_id=HOST_ID,
            status=WellnessStatus.NORMAL.value,
            summary="식사를 잘 하셨고 컨디션 양호합니다.",
            details={"meal": "lunch", "appetite": "good"},
        ),
        WellnessLog(
            id=WELLNESS_IDS[1],
            host_id=HOST_ID,
            status=WellnessStatus.NORMAL.value,
            summary="오후 산책을 마치고 돌아오셨습니다.",
            details={"activity": "walking", "duration_min": 30},
        ),
        WellnessLog(
            id=WELLNESS_IDS[2],
            host_id=HOST_ID,
            status=WellnessStatus.WARNING.value,
            summary="어지러움을 호소하셨습니다. 혈압 체크 권장.",
            details={"symptom": "dizziness", "severity": "mild"},
        ),
    ]
    db.add_all(wellness_entries)
    await db.flush()
    logger.info("seed_wellness_logs_created", count=len(wellness_entries))

    # ── Medications (2 entries) ────────────────────────────────────
    tomorrow_9am = (now + timedelta(days=1)).replace(
        hour=9, minute=0, second=0, microsecond=0
    )
    medications = [
        Medication(
            id=MEDICATION_IDS[0],
            host_id=HOST_ID,
            pill_name="아스피린 100mg",
            schedule_time=tomorrow_9am,
            is_taken=True,
            taken_at=now - timedelta(hours=2),
        ),
        Medication(
            id=MEDICATION_IDS[1],
            host_id=HOST_ID,
            pill_name="혈압약 (아모디핀 5mg)",
            schedule_time=tomorrow_9am + timedelta(hours=12),
            is_taken=False,
            taken_at=None,
        ),
    ]
    db.add_all(medications)
    await db.flush()
    logger.info("seed_medications_created", count=len(medications))


async def main() -> None:
    """Run the seed script."""
    logger.info("seed_starting")
    async with async_session_factory() as db:
        await _clear_demo_data(db)
        await _insert_demo_data(db)
        await db.commit()
    logger.info("seed_completed")


if __name__ == "__main__":
    asyncio.run(main())
