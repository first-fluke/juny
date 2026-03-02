"""Job: Send medication reminder push notifications."""

from typing import Any

import structlog

from src.jobs.base import BaseJob, register_job
from src.lib.dispatch import dispatch_local

logger = structlog.get_logger(__name__)


class MedicationReminderJob(BaseJob):
    """Remind a host to take medication via push notification."""

    @property
    def job_type(self) -> str:
        return "medication.reminder"

    async def execute(self, data: dict[str, Any]) -> dict[str, Any]:
        host_id: str = data.get("host_id", "")
        pill_name: str = data.get("pill_name", "Unknown")
        tokens: list[str] = data.get("tokens", [])

        if not tokens:
            logger.warning("medication_reminder_no_tokens", host_id=host_id)
            return {"sent_count": 0, "skipped": True}

        await dispatch_local(
            "notification.send",
            {
                "tokens": tokens,
                "title": "Medication Reminder",
                "body": f"Time to take {pill_name}",
                "data": {"host_id": host_id, "type": "medication_reminder"},
            },
        )

        logger.info(
            "medication_reminder_dispatched",
            host_id=host_id,
            pill_name=pill_name,
        )
        return {"dispatched": True, "pill_name": pill_name}


register_job(MedicationReminderJob())
