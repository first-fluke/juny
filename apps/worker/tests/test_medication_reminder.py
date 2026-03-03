"""Tests for the medication.reminder job."""

from __future__ import annotations

from unittest.mock import AsyncMock, patch

import pytest
from pydantic import ValidationError

from src.jobs.medication_reminder import MedicationReminderJob


class TestMedicationReminderJob:
    def test_job_type(self) -> None:
        job = MedicationReminderJob()
        assert job.job_type == "medication.reminder"

    @pytest.mark.asyncio
    async def test_execute_invalid_tokens_type(self) -> None:
        """tokens must be a list of strings."""
        job = MedicationReminderJob()
        with pytest.raises(ValidationError):
            await job.execute({"tokens": 123})

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
    @patch(
        "src.jobs.medication_reminder.dispatch_local",
        new_callable=AsyncMock,
    )
    async def test_execute_dispatches(self, mock_dispatch: AsyncMock) -> None:
        mock_dispatch.return_value = {"status": "completed"}

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
        mock_dispatch.assert_called_once_with(
            "notification.send",
            {
                "tokens": ["tok-1"],
                "title": "Medication Reminder",
                "body": "Time to take Aspirin",
                "data": {"host_id": "host-001", "type": "medication_reminder"},
            },
        )
