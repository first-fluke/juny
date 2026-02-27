"""Client for dispatching tasks to the worker.

- local: direct HTTP POST to the worker process.
- staging/prod: Google Cloud Tasks enqueue.
"""

from typing import Any

import httpx
import structlog

from src.lib.config import settings

logger = structlog.get_logger(__name__)


async def dispatch_task(task_type: str, data: dict[str, Any]) -> None:
    """Send a task to the worker.

    In local mode, posts directly to the worker HTTP endpoint.
    In staging/prod, enqueues via Google Cloud Tasks.
    """
    if settings.PROJECT_ENV == "local":
        await _dispatch_local(task_type, data)
    else:
        await _dispatch_cloud_tasks(task_type, data)


async def _dispatch_local(task_type: str, data: dict[str, Any]) -> None:
    """POST directly to the worker process."""
    url = f"{settings.WORKER_URL}/tasks/process"
    async with httpx.AsyncClient() as client:
        response = await client.post(
            url,
            json={"task_type": task_type, "data": data},
            timeout=30.0,
        )
    logger.info(
        "task_dispatched_local",
        task_type=task_type,
        worker_status=response.status_code,
    )


async def _dispatch_cloud_tasks(task_type: str, data: dict[str, Any]) -> None:
    """Enqueue a task via Google Cloud Tasks."""
    import json

    from google.cloud import tasks_v2  # type: ignore[import-untyped]

    client = tasks_v2.CloudTasksClient()
    parent = client.queue_path(
        settings.GOOGLE_CLOUD_PROJECT or "",
        settings.CLOUD_TASKS_LOCATION,
        settings.CLOUD_TASKS_QUEUE or "default",
    )

    task = tasks_v2.Task(
        http_request=tasks_v2.HttpRequest(
            http_method=tasks_v2.HttpMethod.POST,
            url=f"{settings.WORKER_URL}/tasks/process",
            headers={"Content-Type": "application/json"},
            body=json.dumps({"task_type": task_type, "data": data}).encode(),
        )
    )

    created = client.create_task(
        request=tasks_v2.CreateTaskRequest(parent=parent, task=task)
    )
    logger.info(
        "task_dispatched_cloud",
        task_type=task_type,
        task_name=created.name,
    )
