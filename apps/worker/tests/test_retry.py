"""Tests for the with_retry decorator."""

from __future__ import annotations

from unittest.mock import AsyncMock

import httpx
import pytest

from src.lib.retry import with_retry


class TestWithRetry:
    @pytest.mark.asyncio
    async def test_retries_on_connect_error(self) -> None:
        mock_fn = AsyncMock(side_effect=httpx.ConnectError("connection refused"))

        @with_retry(max_attempts=3, min_wait=0, max_wait=0)
        async def flaky() -> str:
            return await mock_fn()

        with pytest.raises(httpx.ConnectError):
            await flaky()

        assert mock_fn.call_count == 3

    @pytest.mark.asyncio
    async def test_retries_on_timeout(self) -> None:
        mock_fn = AsyncMock(side_effect=httpx.ReadTimeout("read timed out"))

        @with_retry(max_attempts=3, min_wait=0, max_wait=0)
        async def flaky() -> str:
            return await mock_fn()

        with pytest.raises(httpx.ReadTimeout):
            await flaky()

        assert mock_fn.call_count == 3

    @pytest.mark.asyncio
    async def test_no_retry_on_value_error(self) -> None:
        mock_fn = AsyncMock(side_effect=ValueError("bad input"))

        @with_retry(max_attempts=3, min_wait=0, max_wait=0)
        async def flaky() -> str:
            return await mock_fn()

        with pytest.raises(ValueError, match="bad input"):
            await flaky()

        assert mock_fn.call_count == 1

    @pytest.mark.asyncio
    async def test_succeeds_after_transient_failure(self) -> None:
        mock_fn = AsyncMock(
            side_effect=[
                httpx.ConnectError("fail 1"),
                httpx.ConnectError("fail 2"),
                "success",
            ]
        )

        @with_retry(max_attempts=3, min_wait=0, max_wait=0)
        async def flaky() -> str:
            return await mock_fn()

        result = await flaky()
        assert result == "success"
        assert mock_fn.call_count == 3

    @pytest.mark.asyncio
    async def test_retries_on_http_status_error(self) -> None:
        request = httpx.Request("POST", "http://example.com")
        response = httpx.Response(500, request=request)
        mock_fn = AsyncMock(
            side_effect=httpx.HTTPStatusError(
                "server error", request=request, response=response
            )
        )

        @with_retry(max_attempts=2, min_wait=0, max_wait=0)
        async def flaky() -> str:
            return await mock_fn()

        with pytest.raises(httpx.HTTPStatusError):
            await flaky()

        assert mock_fn.call_count == 2
