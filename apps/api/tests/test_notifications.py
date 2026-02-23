from __future__ import annotations

import uuid

import pytest

from src.lib.notifications import send_push_notification

RECIPIENT_A = uuid.UUID("00000000-0000-4000-8000-000000000030")
RECIPIENT_B = uuid.UUID("00000000-0000-4000-8000-000000000031")


class TestNotifications:
    @pytest.mark.asyncio
    async def test_send_push_notification_success(self) -> None:
        result = await send_push_notification(
            recipient_id=RECIPIENT_A,
            title="Test Alert",
            body="Something happened",
            data={"key": "value"},
        )

        assert result["success"] is True
        assert "notification_id" in result
        assert result["recipient_id"] == str(RECIPIENT_A)

    @pytest.mark.asyncio
    async def test_send_push_notification_without_data(self) -> None:
        result = await send_push_notification(
            recipient_id=RECIPIENT_B,
            title="Alert",
            body="No extra data",
        )

        assert result["success"] is True
        assert result["recipient_id"] == str(RECIPIENT_B)
