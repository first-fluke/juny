"""Tests for the wellness.escalation job."""

from __future__ import annotations

from unittest.mock import AsyncMock, patch

import pytest
from pydantic import ValidationError

from src.jobs.wellness_escalation import WellnessEscalationJob


class TestWellnessEscalationJob:
    def test_job_type(self) -> None:
        job = WellnessEscalationJob()
        assert job.job_type == "wellness.escalation"

    @pytest.mark.asyncio
    async def test_execute_invalid_contact_tokens_type(self) -> None:
        """contact_tokens must be a list of strings."""
        job = WellnessEscalationJob()
        with pytest.raises(ValidationError):
            await job.execute({"contact_tokens": "not-a-list"})

    @pytest.mark.asyncio
    async def test_execute_no_contacts(self) -> None:
        job = WellnessEscalationJob()
        result = await job.execute(
            {
                "log_id": "log-001",
                "host_id": "host-001",
                "status": "emergency",
                "summary": "Fall detected",
                "contact_tokens": [],
            }
        )
        assert result["escalated"] is False
        assert result["reason"] == "no_contacts"

    @pytest.mark.asyncio
    @patch(
        "src.jobs.wellness_escalation.dispatch_local",
        new_callable=AsyncMock,
    )
    async def test_execute_dispatches(self, mock_dispatch: AsyncMock) -> None:
        mock_dispatch.return_value = {"status": "completed"}

        job = WellnessEscalationJob()
        result = await job.execute(
            {
                "log_id": "log-002",
                "host_id": "host-002",
                "status": "emergency",
                "summary": "Urgent situation",
                "contact_tokens": ["tok-a", "tok-b"],
            }
        )

        assert result["escalated"] is True
        assert result["contact_count"] == 2
        mock_dispatch.assert_called_once()
        call_args = mock_dispatch.call_args
        assert call_args[0][0] == "notification.send"
        data = call_args[0][1]
        assert data["tokens"] == ["tok-a", "tok-b"]
        assert "EMERGENCY" in data["title"]
