"""Tests for the FCM notification provider."""

from __future__ import annotations

import sys
import uuid
from unittest.mock import MagicMock, patch

import pytest


# Fake firebase_admin for import isolation
@pytest.fixture(autouse=True)
def _mock_firebase_admin():
    """Inject fake firebase_admin into sys.modules."""
    fake_firebase_admin = MagicMock()
    fake_messaging = MagicMock()
    fake_firebase_admin.messaging = fake_messaging
    fake_firebase_admin.get_app = MagicMock()
    fake_firebase_admin.initialize_app = MagicMock()

    with patch.dict(
        sys.modules,
        {
            "firebase_admin": fake_firebase_admin,
            "firebase_admin.messaging": fake_messaging,
        },
    ):
        # Clear any cached import of FCM module
        sys.modules.pop("src.lib.notifications.fcm", None)
        yield fake_messaging

    # Cleanup
    sys.modules.pop("src.lib.notifications.fcm", None)


class TestFCMSendToTokensSuccess:
    @pytest.mark.asyncio
    async def test_send_to_tokens_all_success(
        self, _mock_firebase_admin: MagicMock
    ) -> None:
        """3 tokens sent, all succeed."""
        messaging = _mock_firebase_admin

        # Each send_response is successful
        mock_responses = []
        for _ in range(3):
            sr = MagicMock()
            sr.success = True
            sr.exception = None
            mock_responses.append(sr)

        batch_response = MagicMock()
        batch_response.success_count = 3
        batch_response.failure_count = 0
        batch_response.responses = mock_responses

        messaging.send_each_for_multicast.return_value = batch_response
        messaging.Notification.return_value = MagicMock()
        messaging.MulticastMessage.return_value = MagicMock()

        from src.lib.notifications.fcm import FCMNotificationProvider

        provider = FCMNotificationProvider()
        result = await provider.send_to_tokens(
            tokens=["tok-a", "tok-b", "tok-c"],
            title="Test",
            body="Hello",
        )
        assert result["sent_count"] == 3
        assert result["failed_tokens"] == []
        assert result["success"] is True


class TestFCMSendToTokensPartialFailure:
    @pytest.mark.asyncio
    async def test_send_to_tokens_partial_failure(
        self, _mock_firebase_admin: MagicMock
    ) -> None:
        """1 token fails, others succeed."""
        messaging = _mock_firebase_admin

        sr_ok = MagicMock(success=True, exception=None)
        sr_fail = MagicMock(success=False, exception=Exception("InvalidRegistration"))

        batch_response = MagicMock()
        batch_response.success_count = 2
        batch_response.failure_count = 1
        batch_response.responses = [sr_ok, sr_fail, sr_ok]

        messaging.send_each_for_multicast.return_value = batch_response
        messaging.Notification.return_value = MagicMock()
        messaging.MulticastMessage.return_value = MagicMock()

        from src.lib.notifications.fcm import FCMNotificationProvider

        provider = FCMNotificationProvider()
        result = await provider.send_to_tokens(
            tokens=["tok-a", "tok-b", "tok-c"],
            title="Test",
            body="Hello",
        )
        assert result["sent_count"] == 2
        assert result["failed_tokens"] == ["tok-b"]
        assert result["success"] is False


class TestFCMSendToTokensEmpty:
    @pytest.mark.asyncio
    async def test_send_to_tokens_empty(self, _mock_firebase_admin: MagicMock) -> None:
        """Empty token list returns sent_count=0 without calling FCM."""
        from src.lib.notifications.fcm import FCMNotificationProvider

        provider = FCMNotificationProvider()
        result = await provider.send_to_tokens(
            tokens=[],
            title="Test",
            body="Hello",
        )
        assert result["sent_count"] == 0
        assert result["failed_tokens"] == []
        _mock_firebase_admin.send_each_for_multicast.assert_not_called()


class TestFCMSendSingle:
    @pytest.mark.asyncio
    async def test_send_single_recipient(self, _mock_firebase_admin: MagicMock) -> None:
        """send() logs and returns notification_id."""
        from src.lib.notifications.fcm import FCMNotificationProvider

        provider = FCMNotificationProvider()
        result = await provider.send(
            recipient_id=uuid.UUID("00000000-0000-4000-8000-000000000099"),
            title="Test",
            body="Hello",
        )
        assert result["success"] is True
        assert "notification_id" in result
        assert result["recipient_id"] == "00000000-0000-4000-8000-000000000099"


class TestFCMInitialization:
    def test_init_calls_get_app_then_initialize(
        self, _mock_firebase_admin: MagicMock
    ) -> None:
        """__init__ tries get_app, on ValueError calls initialize_app."""
        import firebase_admin

        firebase_admin.get_app.side_effect = ValueError("No default app")

        from src.lib.notifications.fcm import FCMNotificationProvider

        FCMNotificationProvider()
        firebase_admin.initialize_app.assert_called_once()
