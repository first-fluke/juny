"""Job: Clean up expired or stale data."""

from typing import Any

import httpx
import structlog

from src.jobs.base import BaseJob, register_job
from src.lib.config import settings
from src.lib.retry import with_retry

logger = structlog.get_logger(__name__)


class DataCleanupJob(BaseJob):
    """Remove expired data (e.g. old wellness logs, inactive tokens)."""

    @property
    def job_type(self) -> str:
        return "data.cleanup"

    @with_retry()
    async def _call_api(self, headers: dict[str, str], payload: dict[str, Any]) -> int:
        async with httpx.AsyncClient() as client:
            response = await client.post(
                f"{settings.API_BASE_URL}/api/v1/admin/cleanup",
                json=payload,
                headers=headers,
                timeout=30.0,
            )
            response.raise_for_status()
            return response.status_code

    async def execute(self, data: dict[str, Any]) -> dict[str, Any]:
        retention_days: int = data.get("retention_days", 90)
        resource_type: str = data.get("resource_type", "all")

        logger.info(
            "data_cleanup_start",
            retention_days=retention_days,
            resource_type=resource_type,
        )

        headers: dict[str, str] = {}
        if settings.INTERNAL_API_KEY:
            headers["X-Internal-Key"] = settings.INTERNAL_API_KEY

        status_code = await self._call_api(
            headers,
            {"retention_days": retention_days, "resource_type": resource_type},
        )

        logger.info(
            "data_cleanup_complete",
            api_status=status_code,
        )
        return {"cleaned": True, "retention_days": retention_days}


register_job(DataCleanupJob())
