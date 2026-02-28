"""Job: Check for inactive care relations."""

from typing import Any

import httpx
import structlog

from src.jobs.base import BaseJob, register_job
from src.lib.config import settings
from src.lib.retry import with_retry

logger = structlog.get_logger(__name__)


class RelationInactiveCheckJob(BaseJob):
    """Detect care relations with no recent activity."""

    @property
    def job_type(self) -> str:
        return "relation.inactive_check"

    @with_retry()
    async def _call_api(self, headers: dict[str, str], params: dict[str, Any]) -> int:
        async with httpx.AsyncClient() as client:
            response = await client.get(
                f"{settings.API_BASE_URL}/api/v1/admin/inactive-relations",
                params=params,
                headers=headers,
                timeout=15.0,
            )
            response.raise_for_status()
            return response.status_code

    async def execute(self, data: dict[str, Any]) -> dict[str, Any]:
        threshold_days: int = data.get("threshold_days", 30)

        logger.info(
            "relation_inactive_check_start",
            threshold_days=threshold_days,
        )

        headers: dict[str, str] = {}
        if settings.INTERNAL_API_KEY:
            headers["X-Internal-Key"] = settings.INTERNAL_API_KEY

        status_code = await self._call_api(headers, {"threshold_days": threshold_days})

        logger.info(
            "relation_inactive_check_complete",
            api_status=status_code,
        )
        return {"checked": True, "threshold_days": threshold_days}


register_job(RelationInactiveCheckJob())
