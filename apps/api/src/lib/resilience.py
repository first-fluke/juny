"""Resilience utilities: retry and timeout wrappers for external API calls."""

import asyncio
from collections.abc import Callable
from typing import Any, TypeVar

import httpx
from tenacity import (
    retry,
    retry_if_exception_type,
    stop_after_attempt,
    wait_exponential,
)

_F = TypeVar("_F", bound=Callable[..., object])

RETRYABLE_EXCEPTIONS = (
    httpx.ConnectError,
    httpx.TimeoutException,
    httpx.HTTPStatusError,
)


def with_retry(
    max_attempts: int = 3,
    min_wait: int = 1,
    max_wait: int = 5,
) -> Callable[[_F], _F]:
    """Decorate an async function with tenacity retry logic.

    Retries on ``httpx.ConnectError``, ``TimeoutException``, and
    ``HTTPStatusError`` with exponential backoff.
    """
    return retry(
        stop=stop_after_attempt(max_attempts),
        wait=wait_exponential(multiplier=1, min=min_wait, max=max_wait),
        retry=retry_if_exception_type(RETRYABLE_EXCEPTIONS),
        reraise=True,
    )


async def with_timeout(coro: Any, timeout_seconds: float) -> Any:
    """Run *coro* with an ``asyncio.wait_for`` timeout wrapper.

    Raises ``asyncio.TimeoutError`` if the coroutine does not complete
    within *timeout_seconds*.
    """
    return await asyncio.wait_for(coro, timeout=timeout_seconds)
