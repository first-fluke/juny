"""Tests for the wellness.aggregate job."""

from __future__ import annotations

from unittest.mock import AsyncMock, patch

import pytest

from src.jobs.wellness_aggregate import WellnessAggregateJob


class TestWellnessAggregateJob:
    def test_job_type(self) -> None:
        job = WellnessAggregateJob()
        assert job.job_type == "wellness.aggregate"

    @pytest.mark.asyncio
    async def test_execute_missing_params(self) -> None:
        job = WellnessAggregateJob()
        result = await job.execute({})
        assert "error" in result

    @pytest.mark.asyncio
    @patch("src.jobs.wellness_aggregate.httpx.AsyncClient")
    async def test_execute_success(self, mock_client_cls: AsyncMock) -> None:
        mock_client = AsyncMock()
        mock_client_cls.return_value.__aenter__ = AsyncMock(return_value=mock_client)
        mock_client_cls.return_value.__aexit__ = AsyncMock(return_value=None)
        mock_response = AsyncMock()
        mock_response.status_code = 200
        mock_client.get.return_value = mock_response

        job = WellnessAggregateJob()
        result = await job.execute(
            {
                "host_id": "host-001",
                "date": "2026-01-01",
            }
        )
        assert result["aggregated"] is True
        assert result["host_id"] == "host-001"

        # Verify correct admin endpoint is called
        call_args = mock_client.get.call_args
        assert "/api/v1/admin/wellness/aggregate" in call_args.args[0]

    @pytest.mark.asyncio
    @patch("src.jobs.wellness_aggregate.settings")
    @patch("src.jobs.wellness_aggregate.httpx.AsyncClient")
    async def test_execute_sends_internal_key(
        self, mock_client_cls: AsyncMock, mock_settings: AsyncMock
    ) -> None:
        mock_settings.INTERNAL_API_KEY = "test-key"
        mock_settings.API_BASE_URL = "http://localhost:8200"
        mock_client = AsyncMock()
        mock_client_cls.return_value.__aenter__ = AsyncMock(return_value=mock_client)
        mock_client_cls.return_value.__aexit__ = AsyncMock(return_value=None)
        mock_response = AsyncMock()
        mock_response.status_code = 200
        mock_client.get.return_value = mock_response

        job = WellnessAggregateJob()
        await job.execute({"host_id": "host-001", "date": "2026-01-01"})

        call_kwargs = mock_client.get.call_args
        assert call_kwargs.kwargs["headers"]["X-Internal-Key"] == "test-key"
