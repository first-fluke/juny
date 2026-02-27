"""Job: Clean up expired or stale data."""

from typing import Any

import httpx
import structlog

from src.jobs.base import BaseJob, register_job
from src.lib.config import settings

logger = structlog.get_logger(__name__)


class DataCleanupJob(BaseJob):
    """Remove expired data (e.g. old wellness logs, inactive tokens)."""

    @property
    def job_type(self) -> str:
        return "data.cleanup"

    async def execute(self, data: dict[str, Any]) -> dict[str, Any]:
        retention_days: int = data.get("retention_days", 90)
        resource_type: str = data.get("resource_type", "all")

        logger.info(
            "data_cleanup_start",
            retention_days=retention_days,
            resource_type=resource_type,
        )

        # Placeholder: In production, call API admin endpoints
        # to purge stale data beyond the retention period.
        async with httpx.AsyncClient() as client:
            response = await client.post(
                f"{settings.API_BASE_URL}/api/v1/admin/cleanup",
                json={
                    "retention_days": retention_days,
                    "resource_type": resource_type,
                },
                timeout=30.0,
            )

        logger.info(
            "data_cleanup_complete",
            api_status=response.status_code,
        )
        return {"cleaned": True, "retention_days": retention_days}


register_job(DataCleanupJob())
