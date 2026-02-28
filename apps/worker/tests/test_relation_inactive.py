"""Tests for the relation.inactive_check job."""

from __future__ import annotations

from unittest.mock import AsyncMock, MagicMock, patch

import pytest

from src.jobs.relation_inactive import RelationInactiveCheckJob


class TestRelationInactiveCheckJob:
    def test_job_type(self) -> None:
        job = RelationInactiveCheckJob()
        assert job.job_type == "relation.inactive_check"

    @pytest.mark.asyncio
    @patch("src.jobs.relation_inactive.httpx.AsyncClient")
    async def test_execute_success(self, mock_client_cls: AsyncMock) -> None:
        mock_client = AsyncMock()
        mock_client_cls.return_value.__aenter__ = AsyncMock(return_value=mock_client)
        mock_client_cls.return_value.__aexit__ = AsyncMock(return_value=None)
        mock_response = AsyncMock()
        mock_response.status_code = 200
        mock_response.raise_for_status = MagicMock()
        mock_client.get.return_value = mock_response

        job = RelationInactiveCheckJob()
        result = await job.execute({"threshold_days": 14})

        assert result["checked"] is True
        assert result["threshold_days"] == 14
        mock_client.get.assert_called_once()

    @pytest.mark.asyncio
    @patch("src.jobs.relation_inactive.httpx.AsyncClient")
    async def test_execute_default_threshold(self, mock_client_cls: AsyncMock) -> None:
        mock_client = AsyncMock()
        mock_client_cls.return_value.__aenter__ = AsyncMock(return_value=mock_client)
        mock_client_cls.return_value.__aexit__ = AsyncMock(return_value=None)
        mock_response = AsyncMock()
        mock_response.status_code = 200
        mock_response.raise_for_status = MagicMock()
        mock_client.get.return_value = mock_response

        job = RelationInactiveCheckJob()
        result = await job.execute({})

        assert result["threshold_days"] == 30

    @pytest.mark.asyncio
    @patch("src.jobs.relation_inactive.settings")
    @patch("src.jobs.relation_inactive.httpx.AsyncClient")
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
        mock_response.raise_for_status = MagicMock()
        mock_client.get.return_value = mock_response

        job = RelationInactiveCheckJob()
        await job.execute({"threshold_days": 14})

        call_kwargs = mock_client.get.call_args
        assert call_kwargs.kwargs["headers"]["X-Internal-Key"] == "test-key"
