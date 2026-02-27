"""Abstract base for notification providers."""

from __future__ import annotations

import uuid
from abc import ABC, abstractmethod
from typing import Any


class NotificationProvider(ABC):
    """Interface for push notification dispatchers."""

    @abstractmethod
    async def send(
        self,
        *,
        recipient_id: uuid.UUID,
        title: str,
        body: str,
        data: dict[str, Any] | None = None,
    ) -> dict[str, Any]: ...

    @abstractmethod
    async def send_to_tokens(
        self,
        *,
        tokens: list[str],
        title: str,
        body: str,
        data: dict[str, Any] | None = None,
    ) -> dict[str, Any]:
        """Send a notification to specific device tokens."""
        ...
