"""Job: Check for inactive care relations."""

from typing import Any

import httpx
import structlog

from src.jobs.base import BaseJob, register_job
from src.lib.config import settings

logger = structlog.get_logger(__name__)


class RelationInactiveCheckJob(BaseJob):
    """Detect care relations with no recent activity."""

    @property
    def job_type(self) -> str:
        return "relation.inactive_check"

    async def execute(self, data: dict[str, Any]) -> dict[str, Any]:
        threshold_days: int = data.get("threshold_days", 30)

        logger.info(
            "relation_inactive_check_start",
            threshold_days=threshold_days,
        )

        # Placeholder: In production, query the API for relations
        # with no wellness logs in the threshold period, and notify
        # the relevant caregivers.
        async with httpx.AsyncClient() as client:
            response = await client.get(
                f"{settings.API_BASE_URL}/api/v1/admin/inactive-relations",
                params={"threshold_days": threshold_days},
                timeout=15.0,
            )

        logger.info(
            "relation_inactive_check_complete",
            api_status=response.status_code,
        )
        return {"checked": True, "threshold_days": threshold_days}


register_job(RelationInactiveCheckJob())
