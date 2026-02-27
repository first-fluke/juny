"""Factory for creating NotificationProvider instances."""

from src.lib.config import settings
from src.lib.notifications.base import NotificationProvider
from src.lib.notifications.mock import MockNotificationProvider


def create_notification_provider() -> NotificationProvider:
    """Create a notification provider based on settings."""
    if settings.NOTIFICATION_PROVIDER == "fcm":
        from src.lib.notifications.fcm import FCMNotificationProvider  # optional

        return FCMNotificationProvider()
    return MockNotificationProvider()
