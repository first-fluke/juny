"""Tests for the notification.send job."""

from __future__ import annotations

import sys
from unittest.mock import AsyncMock, MagicMock, patch

import pytest

from src.jobs.notification_send import NotificationSendJob


class TestNotificationSendJob:
    def test_job_type(self) -> None:
        job = NotificationSendJob()
        assert job.job_type == "notification.send"

    @pytest.mark.asyncio
    async def test_execute_no_tokens(self) -> None:
        job = NotificationSendJob()
        result = await job.execute({"tokens": [], "title": "T", "body": "B"})
        assert result["sent_count"] == 0

    @pytest.mark.asyncio
    @patch("src.jobs.notification_send.settings")
    async def test_execute_mock_provider(self, mock_settings: object) -> None:
        mock_settings.NOTIFICATION_PROVIDER = "mock"  # type: ignore[attr-defined]
        job = NotificationSendJob()
        result = await job.execute(
            {
                "tokens": ["tok-1", "tok-2"],
                "title": "Hello",
                "body": "World",
            }
        )
        assert result["sent_count"] == 2
        assert result["failed_count"] == 0

    @pytest.mark.asyncio
    @patch("src.jobs.notification_send.settings")
    async def test_execute_fcm_all_success(self, mock_settings: object) -> None:
        """FCM branch: all tokens succeed → failed_tokens is empty."""
        mock_settings.NOTIFICATION_PROVIDER = "fcm"  # type: ignore[attr-defined]

        fake_messaging = MagicMock()
        sr_ok = MagicMock(success=True, exception=None)
        batch_resp = MagicMock()
        batch_resp.success_count = 2
        batch_resp.failure_count = 0
        batch_resp.responses = [sr_ok, sr_ok]
        fake_messaging.send_each_for_multicast.return_value = batch_resp

        fake_firebase = MagicMock()
        fake_firebase.messaging = fake_messaging
        with patch.dict(
            sys.modules,
            {
                "firebase_admin": fake_firebase,
                "firebase_admin.messaging": fake_messaging,
            },
        ):
            job = NotificationSendJob()
            result = await job.execute(
                {
                    "tokens": ["tok-1", "tok-2"],
                    "title": "Hi",
                    "body": "Test",
                }
            )
        assert result["sent_count"] == 2
        assert result["failed_count"] == 0
        assert result["failed_tokens"] == []

    @pytest.mark.asyncio
    @patch("src.jobs.notification_send.settings")
    async def test_execute_fcm_partial_failure(self, mock_settings: object) -> None:
        """FCM branch: 1 token fails → tracked in failed_tokens."""
        mock_settings.NOTIFICATION_PROVIDER = "fcm"  # type: ignore[attr-defined]

        fake_messaging = MagicMock()
        sr_ok = MagicMock(success=True, exception=None)
        sr_fail = MagicMock(success=False, exception=Exception("InvalidRegistration"))
        batch_resp = MagicMock()
        batch_resp.success_count = 1
        batch_resp.failure_count = 1
        batch_resp.responses = [sr_ok, sr_fail]
        fake_messaging.send_each_for_multicast.return_value = batch_resp

        fake_firebase = MagicMock()
        fake_firebase.messaging = fake_messaging
        with patch.dict(
            sys.modules,
            {
                "firebase_admin": fake_firebase,
                "firebase_admin.messaging": fake_messaging,
            },
        ):
            job = NotificationSendJob()
            result = await job.execute(
                {
                    "tokens": ["tok-good", "tok-bad"],
                    "title": "Hi",
                    "body": "Test",
                }
            )
        assert result["sent_count"] == 1
        assert result["failed_count"] == 1
        assert result["failed_tokens"] == ["tok-bad"]

    @pytest.mark.asyncio
    @patch(
        "src.jobs.notification_send._deactivate_failed_tokens",
        new_callable=AsyncMock,
    )
    @patch("src.jobs.notification_send.settings")
    async def test_execute_fcm_calls_deactivation(
        self, mock_settings: object, mock_deactivate: AsyncMock
    ) -> None:
        """FCM branch with failures should call _deactivate_failed_tokens."""
        mock_settings.NOTIFICATION_PROVIDER = "fcm"  # type: ignore[attr-defined]

        fake_messaging = MagicMock()
        sr_ok = MagicMock(success=True, exception=None)
        sr_fail = MagicMock(success=False, exception=Exception("InvalidRegistration"))
        batch_resp = MagicMock()
        batch_resp.success_count = 1
        batch_resp.failure_count = 1
        batch_resp.responses = [sr_ok, sr_fail]
        fake_messaging.send_each_for_multicast.return_value = batch_resp

        fake_firebase = MagicMock()
        fake_firebase.messaging = fake_messaging
        with patch.dict(
            sys.modules,
            {
                "firebase_admin": fake_firebase,
                "firebase_admin.messaging": fake_messaging,
            },
        ):
            job = NotificationSendJob()
            await job.execute(
                {
                    "tokens": ["tok-good", "tok-bad"],
                    "title": "Hi",
                    "body": "Test",
                }
            )
        mock_deactivate.assert_called_once_with(["tok-bad"])

    @pytest.mark.asyncio
    @patch(
        "src.jobs.notification_send._deactivate_failed_tokens",
        new_callable=AsyncMock,
    )
    @patch("src.jobs.notification_send.settings")
    async def test_execute_fcm_deactivation_error_continues(
        self, mock_settings: object, mock_deactivate: AsyncMock
    ) -> None:
        """Deactivation failure should not break the job."""
        mock_settings.NOTIFICATION_PROVIDER = "fcm"  # type: ignore[attr-defined]
        mock_deactivate.side_effect = Exception("API down")

        fake_messaging = MagicMock()
        sr_fail = MagicMock(success=False, exception=Exception("bad"))
        batch_resp = MagicMock()
        batch_resp.success_count = 0
        batch_resp.failure_count = 1
        batch_resp.responses = [sr_fail]
        fake_messaging.send_each_for_multicast.return_value = batch_resp

        fake_firebase = MagicMock()
        fake_firebase.messaging = fake_messaging
        with patch.dict(
            sys.modules,
            {
                "firebase_admin": fake_firebase,
                "firebase_admin.messaging": fake_messaging,
            },
        ):
            job = NotificationSendJob()
            result = await job.execute(
                {"tokens": ["tok-bad"], "title": "Hi", "body": "Test"}
            )
        assert result["failed_count"] == 1
