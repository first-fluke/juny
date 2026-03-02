"""Task processing router — dispatches payloads to registered jobs."""

from typing import Any

import structlog
from fastapi import APIRouter, HTTPException
from opentelemetry import trace
from pydantic import BaseModel

from src.jobs.base import get_job, list_jobs
from src.lib.idempotency import release_claim, try_claim

tracer = trace.get_tracer(__name__)

logger = structlog.get_logger(__name__)

router = APIRouter(tags=["Tasks"])


class TaskPayload(BaseModel):
    task_type: str
    data: dict[str, Any]


@router.post("/process")
async def process_task(payload: TaskPayload) -> dict[str, Any]:
    """Execute a registered job synchronously and return the result."""
    job = get_job(payload.task_type)
    if not job:
        raise HTTPException(
            status_code=400,
            detail="Unknown job type",
        )

    if not try_claim(payload.task_type, payload.data):
        logger.info("job_duplicate_skipped", job_type=payload.task_type)
        return {"status": "duplicate"}

    logger.info("job_execute_start", job_type=payload.task_type)
    try:
        with tracer.start_as_current_span(
            f"job.execute:{payload.task_type}",
            attributes={"job.type": payload.task_type},
        ):
            result = await job.execute(payload.data)
    except Exception:
        release_claim(payload.task_type, payload.data)
        raise
    logger.info("job_execute_complete", job_type=payload.task_type)
    return {"status": "completed", **result}


@router.get("/jobs")
async def list_registered_jobs() -> dict[str, list[str]]:
    """List all registered job types."""
    return {"job_types": list_jobs()}
