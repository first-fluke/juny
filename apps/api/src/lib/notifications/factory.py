"""Factory for creating NotificationProvider instances."""

import structlog

from src.lib.config import settings
from src.lib.notifications.base import NotificationProvider
from src.lib.notifications.mock import MockNotificationProvider

logger = structlog.get_logger(__name__)


def create_notification_provider() -> NotificationProvider:
    """Create a notification provider based on settings.

    In production, mock provider is not allowed — raises ValueError.
    """
    if settings.NOTIFICATION_PROVIDER == "fcm":
        from src.lib.notifications.fcm import FCMNotificationProvider  # optional

        return FCMNotificationProvider()

    if settings.PROJECT_ENV == "prod":
        msg = (
            "Mock notification provider is not allowed in production. "
            "Set NOTIFICATION_PROVIDER=fcm and configure FCM credentials."
        )
        raise ValueError(msg)

    return MockNotificationProvider()
