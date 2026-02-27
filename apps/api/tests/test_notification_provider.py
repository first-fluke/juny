"""Tests for the notification provider module."""

from __future__ import annotations

import uuid
from unittest.mock import MagicMock, patch

import pytest

from src.lib.notifications import send_push_notification, send_to_tokens
from src.lib.notifications.factory import create_notification_provider
from src.lib.notifications.mock import MockNotificationProvider

RECIPIENT_ID = uuid.UUID("00000000-0000-4000-8000-000000000080")


# ---------------------------------------------------------------------------
# MockNotificationProvider
# ---------------------------------------------------------------------------


class TestMockNotificationProvider:
    @pytest.mark.asyncio
    async def test_send_returns_success(self) -> None:
        provider = MockNotificationProvider()
        result = await provider.send(
            recipient_id=RECIPIENT_ID,
            title="Hello",
            body="World",
        )
        assert result["success"] is True
        assert result["recipient_id"] == str(RECIPIENT_ID)
        assert "notification_id" in result

    @pytest.mark.asyncio
    async def test_send_with_data(self) -> None:
        provider = MockNotificationProvider()
        result = await provider.send(
            recipient_id=RECIPIENT_ID,
            title="Hello",
            body="World",
            data={"key": "value"},
        )
        assert result["success"] is True

    @pytest.mark.asyncio
    async def test_send_to_tokens_returns_success(self) -> None:
        provider = MockNotificationProvider()
        result = await provider.send_to_tokens(
            tokens=["token-a", "token-b"],
            title="Title",
            body="Body",
        )
        assert result["success"] is True
        assert result["sent_count"] == 2
        assert result["failed_tokens"] == []

    @pytest.mark.asyncio
    async def test_send_to_tokens_empty(self) -> None:
        provider = MockNotificationProvider()
        result = await provider.send_to_tokens(
            tokens=[],
            title="Title",
            body="Body",
        )
        assert result["success"] is True
        assert result["sent_count"] == 0


# ---------------------------------------------------------------------------
# Factory
# ---------------------------------------------------------------------------


class TestNotificationFactory:
    @patch("src.lib.notifications.factory.settings")
    def test_mock_provider(self, mock_settings: MagicMock) -> None:
        mock_settings.NOTIFICATION_PROVIDER = "mock"
        provider = create_notification_provider()
        assert isinstance(provider, MockNotificationProvider)

    @patch("src.lib.notifications.factory.settings")
    def test_fcm_provider(self, mock_settings: MagicMock) -> None:
        mock_settings.NOTIFICATION_PROVIDER = "fcm"
        # firebase_admin is optional — mock it if not installed
        fake_fb = MagicMock()
        fake_fb.get_app.side_effect = ValueError("no app")
        with patch.dict(
            "sys.modules",
            {
                "firebase_admin": fake_fb,
                "firebase_admin.messaging": MagicMock(),
                "firebase_admin.credentials": MagicMock(),
            },
        ):
            import sys

            sys.modules.pop("src.lib.notifications.fcm", None)
            provider = create_notification_provider()
            from src.lib.notifications.fcm import FCMNotificationProvider

            assert isinstance(provider, FCMNotificationProvider)

    @patch("src.lib.notifications.factory.settings")
    def test_default_is_mock(self, mock_settings: MagicMock) -> None:
        mock_settings.NOTIFICATION_PROVIDER = "mock"
        provider = create_notification_provider()
        assert isinstance(provider, MockNotificationProvider)


# ---------------------------------------------------------------------------
# Backward Compatibility
# ---------------------------------------------------------------------------


class TestBackwardCompat:
    @pytest.mark.asyncio
    async def test_send_push_notification_function(self) -> None:
        """Verify the legacy function still works."""
        # Reset the cached provider
        import src.lib.notifications as notif_mod

        notif_mod._provider = None

        result = await send_push_notification(
            recipient_id=RECIPIENT_ID,
            title="Test",
            body="Backward compat",
        )
        assert result["success"] is True
        assert result["recipient_id"] == str(RECIPIENT_ID)

    @pytest.mark.asyncio
    async def test_send_to_tokens_function(self) -> None:
        """Verify the send_to_tokens convenience function works."""
        import src.lib.notifications as notif_mod

        notif_mod._provider = None

        result = await send_to_tokens(
            tokens=["tok-1", "tok-2"],
            title="Test",
            body="Token compat",
        )
        assert result["success"] is True
        assert result["sent_count"] == 2
