"""Job: Aggregate daily wellness statistics for a host."""

from typing import Any

import httpx
import structlog

from src.jobs.base import BaseJob, register_job
from src.lib.config import settings

logger = structlog.get_logger(__name__)


class WellnessAggregateJob(BaseJob):
    """Aggregate daily wellness logs for a host via API."""

    @property
    def job_type(self) -> str:
        return "wellness.aggregate"

    async def execute(self, data: dict[str, Any]) -> dict[str, Any]:
        host_id: str = data.get("host_id", "")
        date: str = data.get("date", "")

        if not host_id or not date:
            logger.warning("wellness_aggregate_missing_params")
            return {"error": "host_id and date are required"}

        logger.info(
            "wellness_aggregate_start",
            host_id=host_id,
            date=date,
        )

        headers: dict[str, str] = {}
        if settings.INTERNAL_API_KEY:
            headers["X-Internal-Key"] = settings.INTERNAL_API_KEY

        async with httpx.AsyncClient() as client:
            response = await client.get(
                f"{settings.API_BASE_URL}/api/v1/admin/wellness/aggregate",
                params={"host_id": host_id, "date": date},
                headers=headers,
                timeout=15.0,
            )

        logger.info(
            "wellness_aggregate_complete",
            host_id=host_id,
            date=date,
            api_status=response.status_code,
        )
        return {"host_id": host_id, "date": date, "aggregated": True}


register_job(WellnessAggregateJob())
