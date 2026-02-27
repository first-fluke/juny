"""Base job class and registry for the worker."""

from abc import ABC, abstractmethod
from typing import Any

import structlog

logger = structlog.get_logger(__name__)

_registry: dict[str, "BaseJob"] = {}


class BaseJob(ABC):
    """Abstract base for all worker jobs."""

    @property
    @abstractmethod
    def job_type(self) -> str:
        """Unique identifier for this job type (e.g. 'notification.send')."""
        ...

    @abstractmethod
    async def execute(self, data: dict[str, Any]) -> dict[str, Any]:
        """Execute the job with the given payload."""
        ...


def register_job(job: BaseJob) -> None:
    """Register a job in the global registry."""
    if job.job_type in _registry:
        logger.warning("job_type_overwritten", job_type=job.job_type)
    _registry[job.job_type] = job
    logger.info("job_registered", job_type=job.job_type)


def get_job(job_type: str) -> BaseJob | None:
    """Look up a registered job by type."""
    return _registry.get(job_type)


def list_jobs() -> list[str]:
    """Return all registered job types."""
    return list(_registry.keys())
