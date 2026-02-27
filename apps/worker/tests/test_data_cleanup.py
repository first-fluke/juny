"""Tests for the data.cleanup job."""

from __future__ import annotations

from unittest.mock import AsyncMock, patch

import pytest

from src.jobs.data_cleanup import DataCleanupJob


class TestDataCleanupJob:
    def test_job_type(self) -> None:
        job = DataCleanupJob()
        assert job.job_type == "data.cleanup"

    @pytest.mark.asyncio
    @patch("src.jobs.data_cleanup.httpx.AsyncClient")
    async def test_execute_success(self, mock_client_cls: AsyncMock) -> None:
        mock_client = AsyncMock()
        mock_client_cls.return_value.__aenter__ = AsyncMock(return_value=mock_client)
        mock_client_cls.return_value.__aexit__ = AsyncMock(return_value=None)
        mock_response = AsyncMock()
        mock_response.status_code = 200
        mock_client.post.return_value = mock_response

        job = DataCleanupJob()
        result = await job.execute({"retention_days": 60})
        assert result["cleaned"] is True
        assert result["retention_days"] == 60
