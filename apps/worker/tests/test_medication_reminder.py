"""Tests for the medication.reminder job."""

from __future__ import annotations

from unittest.mock import AsyncMock, MagicMock, patch

import pytest

from src.jobs.medication_reminder import MedicationReminderJob


class TestMedicationReminderJob:
    def test_job_type(self) -> None:
        job = MedicationReminderJob()
        assert job.job_type == "medication.reminder"

    @pytest.mark.asyncio
    async def test_execute_no_tokens(self) -> None:
        job = MedicationReminderJob()
        result = await job.execute(
            {
                "host_id": "abc",
                "pill_name": "Aspirin",
                "tokens": [],
            }
        )
        assert result["sent_count"] == 0
        assert result["skipped"] is True

    @pytest.mark.asyncio
    @patch("src.jobs.medication_reminder.httpx.AsyncClient")
    async def test_execute_dispatches(self, mock_client_cls: AsyncMock) -> None:
        mock_client = AsyncMock()
        mock_client_cls.return_value.__aenter__ = AsyncMock(return_value=mock_client)
        mock_client_cls.return_value.__aexit__ = AsyncMock(return_value=None)
        mock_response = AsyncMock()
        mock_response.status_code = 200
        mock_response.raise_for_status = MagicMock()
        mock_client.post.return_value = mock_response

        job = MedicationReminderJob()
        result = await job.execute(
            {
                "host_id": "host-001",
                "pill_name": "Aspirin",
                "tokens": ["tok-1"],
            }
        )
        assert result["dispatched"] is True
        assert result["pill_name"] == "Aspirin"
