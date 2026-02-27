"""Mock notification provider — logs instead of sending."""

from __future__ import annotations

import uuid
from typing import Any

import structlog

from src.lib.notifications.base import NotificationProvider

logger = structlog.get_logger(__name__)


class MockNotificationProvider(NotificationProvider):
    """Logs notifications without delivering them."""

    async def send(
        self,
        *,
        recipient_id: uuid.UUID,
        title: str,
        body: str,
        data: dict[str, Any] | None = None,
    ) -> dict[str, Any]:
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

    async def send_to_tokens(
        self,
        *,
        tokens: list[str],
        title: str,
        body: str,
        data: dict[str, Any] | None = None,
    ) -> dict[str, Any]:
        notification_id = str(uuid.uuid4())
        logger.warning(
            "push_notification_tokens_mock",
            notification_id=notification_id,
            token_count=len(tokens),
            title=title,
            body=body,
            data=data,
        )
        return {
            "success": True,
            "notification_id": notification_id,
            "sent_count": len(tokens),
            "failed_tokens": [],
        }
