"""Tests for the wellness.escalation job."""

from __future__ import annotations

from unittest.mock import AsyncMock, patch

import pytest

from src.jobs.wellness_escalation import WellnessEscalationJob


class TestWellnessEscalationJob:
    def test_job_type(self) -> None:
        job = WellnessEscalationJob()
        assert job.job_type == "wellness.escalation"

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
    @patch("src.jobs.wellness_escalation.httpx.AsyncClient")
    async def test_execute_dispatches(self, mock_client_cls: AsyncMock) -> None:
        mock_client = AsyncMock()
        mock_client_cls.return_value.__aenter__ = AsyncMock(return_value=mock_client)
        mock_client_cls.return_value.__aexit__ = AsyncMock(return_value=None)
        mock_response = AsyncMock()
        mock_response.status_code = 200
        mock_client.post.return_value = mock_response

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
        mock_client.post.assert_called_once()
        call_args = mock_client.post.call_args
        payload = call_args.kwargs.get("json") or call_args[1].get("json")
        assert payload["task_type"] == "notification.send"
        assert payload["data"]["tokens"] == ["tok-a", "tok-b"]
        assert "EMERGENCY" in payload["data"]["title"]
