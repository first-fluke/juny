"""Job: Aggregate daily wellness statistics for a host."""

from typing import Any

import httpx
import structlog

from src.jobs.base import BaseJob, register_job
from src.jobs.schemas import WellnessAggregatePayload
from src.lib.config import settings
from src.lib.retry import with_retry

logger = structlog.get_logger(__name__)


class WellnessAggregateJob(BaseJob):
    """Aggregate daily wellness logs for a host via API."""

    @property
    def job_type(self) -> str:
        return "wellness.aggregate"

    @with_retry()
    async def _call_api(self, headers: dict[str, str], params: dict[str, Any]) -> int:
        async with httpx.AsyncClient() as client:
            response = await client.get(
                f"{settings.API_BASE_URL}/api/v1/admin/wellness/aggregate",
                params=params,
                headers=headers,
                timeout=15.0,
            )
            response.raise_for_status()
            return response.status_code

    async def execute(self, data: dict[str, Any]) -> dict[str, Any]:
        payload = WellnessAggregatePayload.model_validate(data)

        logger.info(
            "wellness_aggregate_start",
            host_id=payload.host_id,
            date=payload.date,
        )

        headers: dict[str, str] = {}
        if settings.INTERNAL_API_KEY:
            headers["X-Internal-Key"] = settings.INTERNAL_API_KEY

        status_code = await self._call_api(
            headers, {"host_id": payload.host_id, "date": payload.date}
        )

        logger.info(
            "wellness_aggregate_complete",
            host_id=payload.host_id,
            date=payload.date,
            api_status=status_code,
        )
        return {
            "host_id": payload.host_id,
            "date": payload.date,
            "aggregated": True,
        }


register_job(WellnessAggregateJob())
