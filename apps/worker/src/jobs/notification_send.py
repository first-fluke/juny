"""Job: Send push notifications via FCM."""

from typing import Any

import httpx
import structlog

from src.jobs.base import BaseJob, register_job
from src.lib.config import settings
from src.lib.retry import with_retry

logger = structlog.get_logger(__name__)


@with_retry(max_attempts=3, min_wait=1, max_wait=5)
async def _deactivate_failed_tokens(tokens: list[str]) -> None:
    """Call the API to deactivate failed FCM tokens."""
    url = f"{settings.API_BASE_URL}/api/v1/admin/tokens/deactivate"
    headers: dict[str, str] = {}
    if settings.INTERNAL_API_KEY:
        headers["X-Internal-Key"] = settings.INTERNAL_API_KEY
    async with httpx.AsyncClient() as client:
        resp = await client.post(
            url, json={"tokens": tokens}, headers=headers, timeout=10.0
        )
        resp.raise_for_status()


class NotificationSendJob(BaseJob):
    """Send FCM push notifications to device tokens."""

    @property
    def job_type(self) -> str:
        return "notification.send"

    async def execute(self, data: dict[str, Any]) -> dict[str, Any]:
        tokens: list[str] = data.get("tokens", [])
        title: str = data.get("title", "")
        body: str = data.get("body", "")
        extra: dict[str, str] = data.get("data", {})

        if not tokens:
            logger.warning("notification_send_no_tokens")
            return {"sent_count": 0}

        if settings.NOTIFICATION_PROVIDER == "fcm":
            from firebase_admin import messaging  # optional dep

            notification = messaging.Notification(title=title, body=body)
            message = messaging.MulticastMessage(
                tokens=tokens,
                notification=notification,
                data={k: str(v) for k, v in extra.items()},
            )
            response: messaging.BatchResponse = messaging.send_each_for_multicast(
                message
            )

            failed_tokens: list[str] = []
            for idx, send_response in enumerate(response.responses):
                if not send_response.success:
                    failed_tokens.append(tokens[idx])
                    logger.warning(
                        "notification_send_token_failed",
                        token=tokens[idx][:20] + "...",
                        error=str(send_response.exception),
                    )

            logger.info(
                "notification_send_complete",
                success=response.success_count,
                failure=response.failure_count,
            )

            if failed_tokens:
                try:
                    await _deactivate_failed_tokens(failed_tokens)
                except Exception:
                    logger.exception("failed_token_deactivation_error")

            return {
                "sent_count": response.success_count,
                "failed_count": response.failure_count,
                "failed_tokens": failed_tokens,
            }

        # Mock fallback
        logger.warning("notification_send_mock", token_count=len(tokens))
        return {"sent_count": len(tokens), "failed_count": 0}


register_job(NotificationSendJob())
