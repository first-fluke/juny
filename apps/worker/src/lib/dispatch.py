"""Local dispatch for sub-tasks within the same worker process."""

from typing import Any

import structlog

from src.jobs.base import get_job
from src.lib.idempotency import release_claim, try_claim

logger = structlog.get_logger(__name__)


async def dispatch_local(task_type: str, data: dict[str, Any]) -> dict[str, Any]:
    """Execute a registered job locally, with idempotency protection."""
    job = get_job(task_type)
    if not job:
        msg = f"Unknown job type: {task_type}"
        raise ValueError(msg)

    if not try_claim(task_type, data):
        logger.info("dispatch_local_duplicate", job_type=task_type)
        return {"status": "duplicate"}

    try:
        result = await job.execute(data)
    except Exception:
        release_claim(task_type, data)
        raise

    logger.info("dispatch_local_complete", job_type=task_type)
    return {"status": "completed", **result}
