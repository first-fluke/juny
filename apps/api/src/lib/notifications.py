"""Async push notification dispatcher (mock implementation).

This module provides a fire-and-forget notification interface.
The current implementation logs the notification; a production adapter
(e.g. FCM, APNs, Cloud Tasks) can be swapped in later.
"""

from __future__ import annotations

import uuid
from typing import Any

import structlog

logger = structlog.get_logger(__name__)


async def send_push_notification(
    *,
    recipient_id: uuid.UUID,
    title: str,
    body: str,
    data: dict[str, Any] | None = None,
) -> dict[str, Any]:
    """Send a push notification to a user device.

    Currently a mock that logs the notification payload.
    Replace the body with a real provider (FCM / APNs / SNS) in production.

    Returns:
        A dict with ``success`` flag and a mock ``notification_id``.
    """
    notification_id = str(uuid.uuid4())

    logger.warning(
        "push_notification_mock",
        notification_id=notification_id,
        recipient_id=str(recipient_id),
        title=title,
        body=body,
        data=data,
    )

    return {
        "success": True,
        "notification_id": notification_id,
        "recipient_id": str(recipient_id),
    }
