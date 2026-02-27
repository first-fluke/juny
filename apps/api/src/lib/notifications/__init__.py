"""Notification provider package.

Exposes ``send_push_notification`` for backward compatibility with
existing callers (AI tools, tests), and ``send_to_tokens`` for
token-based delivery via the active provider.
"""

from __future__ import annotations

import uuid
from typing import Any

from src.lib.notifications.base import NotificationProvider
from src.lib.notifications.factory import create_notification_provider

__all__ = [
    "NotificationProvider",
    "create_notification_provider",
    "send_push_notification",
    "send_to_tokens",
]

_provider: NotificationProvider | None = None


def _get_provider() -> NotificationProvider:
    global _provider
    if _provider is None:
        _provider = create_notification_provider()
    return _provider


async def send_push_notification(
    *,
    recipient_id: uuid.UUID,
    title: str,
    body: str,
    data: dict[str, Any] | None = None,
) -> dict[str, Any]:
    """Backward-compatible function that delegates to the active provider."""
    provider = _get_provider()
    return await provider.send(
        recipient_id=recipient_id,
        title=title,
        body=body,
        data=data,
    )


async def send_to_tokens(
    *,
    tokens: list[str],
    title: str,
    body: str,
    data: dict[str, Any] | None = None,
) -> dict[str, Any]:
    """Send a push notification to specific device tokens."""
    provider = _get_provider()
    return await provider.send_to_tokens(
        tokens=tokens,
        title=title,
        body=body,
        data=data,
    )
