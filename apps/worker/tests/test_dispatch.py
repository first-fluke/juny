"""Tests for local dispatch."""

from __future__ import annotations

from unittest.mock import AsyncMock, patch

import pytest

from src.lib.dispatch import dispatch_local
from src.lib.idempotency import clear


class TestDispatchLocal:
    def setup_method(self) -> None:
        clear()

    @pytest.mark.asyncio
    async def test_unknown_job_raises(self) -> None:
        with pytest.raises(ValueError, match="Unknown job type"):
            await dispatch_local("nonexistent.job", {})

    @pytest.mark.asyncio
    @patch("src.lib.dispatch.get_job")
    async def test_successful_dispatch(self, mock_get_job: AsyncMock) -> None:
        mock_job = AsyncMock()
        mock_job.execute.return_value = {"sent": True}
        mock_get_job.return_value = mock_job

        result = await dispatch_local("notification.send", {"tokens": ["a"]})

        assert result["status"] == "completed"
        assert result["sent"] is True
        mock_job.execute.assert_called_once_with({"tokens": ["a"]})

    @pytest.mark.asyncio
    @patch("src.lib.dispatch.get_job")
    async def test_duplicate_returns_duplicate(self, mock_get_job: AsyncMock) -> None:
        mock_job = AsyncMock()
        mock_job.execute.return_value = {"ok": True}
        mock_get_job.return_value = mock_job

        data = {"tokens": ["b"]}
        await dispatch_local("notification.send", data)

        result = await dispatch_local("notification.send", data)
        assert result["status"] == "duplicate"
        # execute should only have been called once (first dispatch)
        mock_job.execute.assert_called_once()

    @pytest.mark.asyncio
    @patch("src.lib.dispatch.get_job")
    async def test_release_claim_on_failure(self, mock_get_job: AsyncMock) -> None:
        mock_job = AsyncMock()
        mock_job.execute.side_effect = RuntimeError("boom")
        mock_get_job.return_value = mock_job

        data = {"tokens": ["c"]}
        with pytest.raises(RuntimeError, match="boom"):
            await dispatch_local("notification.send", data)

        # After failure, claim should be released — retry should succeed
        mock_job.execute.side_effect = None
        mock_job.execute.return_value = {"retried": True}
        result = await dispatch_local("notification.send", data)
        assert result["status"] == "completed"
