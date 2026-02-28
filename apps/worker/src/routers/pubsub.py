"""Pub/Sub push subscription router — receives messages from GCP Pub/Sub."""

import base64
import json
from typing import Any

import structlog
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

from src.jobs.base import get_job
from src.lib.idempotency import is_duplicate, mark_processed

logger = structlog.get_logger(__name__)

router = APIRouter(tags=["PubSub"])


class PubSubMessage(BaseModel):
    data: str  # base64-encoded
    attributes: dict[str, str] = {}
    messageId: str = ""


class PubSubEnvelope(BaseModel):
    message: PubSubMessage
    subscription: str = ""


@router.post("/pubsub")
async def handle_pubsub_push(envelope: PubSubEnvelope) -> dict[str, Any]:
    """Handle a Pub/Sub push message and dispatch to the appropriate job."""
    try:
        raw = base64.b64decode(envelope.message.data)
        payload = json.loads(raw)
    except Exception as exc:
        raise HTTPException(status_code=400, detail="Invalid message encoding") from exc

    task_type = payload.get("task_type")
    if not task_type:
        raise HTTPException(status_code=400, detail="Missing task_type in payload")

    job = get_job(task_type)
    if not job:
        raise HTTPException(status_code=400, detail=f"Unknown job type: {task_type}")

    idempotency_key = envelope.message.messageId or None
    data = payload.get("data", {})

    if is_duplicate(task_type, data, idempotency_key=idempotency_key):
        logger.info("pubsub_duplicate_skipped", job_type=task_type)
        return {"status": "duplicate"}

    logger.info("pubsub_job_execute_start", job_type=task_type)
    result = await job.execute(data)
    mark_processed(task_type, data, idempotency_key=idempotency_key)
    logger.info("pubsub_job_execute_complete", job_type=task_type)
    return {"status": "completed", **result}
