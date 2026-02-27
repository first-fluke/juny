"""Tests for the notification.send job."""

from __future__ import annotations

from unittest.mock import patch

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
