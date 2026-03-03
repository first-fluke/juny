"""Job: Escalate critical wellness events to emergency contacts."""

from typing import Any

import structlog

from src.jobs.base import BaseJob, register_job
from src.jobs.schemas import WellnessEscalationPayload
from src.lib.dispatch import dispatch_local

logger = structlog.get_logger(__name__)


class WellnessEscalationJob(BaseJob):
    """Send urgent notifications for emergency wellness events."""

    @property
    def job_type(self) -> str:
        return "wellness.escalation"

    async def execute(self, data: dict[str, Any]) -> dict[str, Any]:
        payload = WellnessEscalationPayload.model_validate(data)

        if not payload.contact_tokens:
            logger.warning(
                "wellness_escalation_no_contacts",
                log_id=payload.log_id,
                host_id=payload.host_id,
            )
            return {"escalated": False, "reason": "no_contacts"}

        await dispatch_local(
            "notification.send",
            {
                "tokens": payload.contact_tokens,
                "title": f"URGENT: Wellness {payload.status.upper()}",
                "body": payload.summary or "Immediate attention required",
                "data": {
                    "log_id": payload.log_id,
                    "host_id": payload.host_id,
                    "type": "wellness_escalation",
                },
            },
        )

        logger.info(
            "wellness_escalation_dispatched",
            log_id=payload.log_id,
            host_id=payload.host_id,
            contact_count=len(payload.contact_tokens),
        )
        return {
            "escalated": True,
            "contact_count": len(payload.contact_tokens),
        }


register_job(WellnessEscalationJob())
