"""Job: Escalate critical wellness events to emergency contacts."""

from typing import Any

import httpx
import structlog

from src.jobs.base import BaseJob, register_job

logger = structlog.get_logger(__name__)


class WellnessEscalationJob(BaseJob):
    """Send urgent notifications for emergency wellness events."""

    @property
    def job_type(self) -> str:
        return "wellness.escalation"

    async def execute(self, data: dict[str, Any]) -> dict[str, Any]:
        log_id: str = data.get("log_id", "")
        host_id: str = data.get("host_id", "")
        status: str = data.get("status", "")
        summary: str = data.get("summary", "")
        contact_tokens: list[str] = data.get("contact_tokens", [])

        if not contact_tokens:
            logger.warning(
                "wellness_escalation_no_contacts",
                log_id=log_id,
                host_id=host_id,
            )
            return {"escalated": False, "reason": "no_contacts"}

        # Dispatch FCM via the notification.send job (self-referencing)
        async with httpx.AsyncClient() as client:
            response = await client.post(
                "http://localhost:8280/tasks/process",
                json={
                    "task_type": "notification.send",
                    "data": {
                        "tokens": contact_tokens,
                        "title": f"URGENT: Wellness {status.upper()}",
                        "body": summary or "Immediate attention required",
                        "data": {
                            "log_id": log_id,
                            "host_id": host_id,
                            "type": "wellness_escalation",
                        },
                    },
                },
                timeout=10.0,
            )

        logger.info(
            "wellness_escalation_dispatched",
            log_id=log_id,
            host_id=host_id,
            contact_count=len(contact_tokens),
            dispatch_status=response.status_code,
        )
        return {
            "escalated": True,
            "contact_count": len(contact_tokens),
        }


register_job(WellnessEscalationJob())
