"""Tests for resilience utilities (retry + timeout)."""

from __future__ import annotations

import asyncio

import httpx
import pytest

from src.lib.resilience import with_retry, with_timeout


class TestWithRetry:
    @pytest.mark.asyncio
    async def test_retry_success_on_third_attempt(self) -> None:
        call_count = 0

        @with_retry(max_attempts=3, min_wait=0, max_wait=0)
        async def flaky() -> str:
            nonlocal call_count
            call_count += 1
            if call_count < 3:
                raise httpx.ConnectError("connection refused")
            return "ok"

        result = await flaky()
        assert result == "ok"
        assert call_count == 3

    @pytest.mark.asyncio
    async def test_retry_exhausted(self) -> None:
        @with_retry(max_attempts=2, min_wait=0, max_wait=0)
        async def always_fails() -> str:
            raise httpx.TimeoutException("timeout")

        with pytest.raises(httpx.TimeoutException):
            await always_fails()

    @pytest.mark.asyncio
    async def test_non_retryable_exception_propagates(self) -> None:
        @with_retry(max_attempts=3, min_wait=0, max_wait=0)
        async def raises_value_error() -> str:
            raise ValueError("not retryable")

        with pytest.raises(ValueError, match="not retryable"):
            await raises_value_error()


class TestWithTimeout:
    @pytest.mark.asyncio
    async def test_timeout_success(self) -> None:
        async def fast() -> str:
            return "done"

        result = await with_timeout(fast(), timeout_seconds=5.0)
        assert result == "done"

    @pytest.mark.asyncio
    async def test_timeout_exceeded(self) -> None:
        async def slow() -> str:
            await asyncio.sleep(10)
            return "never"

        with pytest.raises(asyncio.TimeoutError):
            await with_timeout(slow(), timeout_seconds=0.01)
