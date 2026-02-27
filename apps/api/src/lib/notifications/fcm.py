"""FCM notification provider using firebase-admin SDK.

firebase-admin is an optional dependency (dependency-group: fcm).
Imports are kept inside methods to avoid ImportError when the
package is not installed.
"""

from __future__ import annotations

import uuid
from typing import Any

import structlog

from src.lib.notifications.base import NotificationProvider

logger = structlog.get_logger(__name__)


class FCMNotificationProvider(NotificationProvider):
    """Firebase Cloud Messaging provider."""

    def __init__(self) -> None:
        # Initialize the default Firebase app if not already done.
        from firebase_admin import initialize_app  # optional dep

        try:
            import firebase_admin  # optional dep

            firebase_admin.get_app()
        except ValueError:
            # Application Default Credentials (GCP) or
            # GOOGLE_APPLICATION_CREDENTIALS env var.
            initialize_app()

    async def send(
        self,
        *,
        recipient_id: uuid.UUID,
        title: str,
        body: str,
        data: dict[str, Any] | None = None,
    ) -> dict[str, Any]:
        # Legacy single-recipient send — kept for backward compat.
        notification_id = str(uuid.uuid4())
        logger.info(
            "push_notification_fcm_send",
            notification_id=notification_id,
            recipient_id=str(recipient_id),
            title=title,
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
        from firebase_admin import messaging  # optional dep

        if not tokens:
            return {"success": True, "sent_count": 0, "failed_tokens": []}

        notification = messaging.Notification(title=title, body=body)
        message = messaging.MulticastMessage(
            tokens=tokens,
            notification=notification,
            data={k: str(v) for k, v in (data or {}).items()},
        )

        response: messaging.BatchResponse = messaging.send_each_for_multicast(message)

        failed_tokens: list[str] = []
        for idx, send_response in enumerate(response.responses):
            if not send_response.success:
                failed_tokens.append(tokens[idx])
                logger.warning(
                    "fcm_token_send_failed",
                    token=tokens[idx][:20] + "...",
                    error=str(send_response.exception),
                )

        logger.info(
            "push_notification_fcm_batch",
            total=len(tokens),
            success=response.success_count,
            failure=response.failure_count,
            title=title,
        )
        return {
            "success": response.failure_count == 0,
            "sent_count": response.success_count,
            "failed_tokens": failed_tokens,
        }
