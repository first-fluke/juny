"""Resilience utilities: retry and timeout wrappers for external API calls."""

import asyncio
from collections.abc import Callable
from typing import Any, TypeVar

import httpx
from tenacity import (
    RetryCallState,
    retry,
    retry_base,
    stop_after_attempt,
    wait_exponential,
)

_F = TypeVar("_F", bound=Callable[..., object])

RETRYABLE_EXCEPTIONS: tuple[type[Exception], ...] = (
    httpx.ConnectError,
    httpx.TimeoutException,
)


class _retry_if_server_error(retry_base):
    """Retry on connection/timeout errors and HTTP 5xx status errors."""

    def __call__(self, retry_state: RetryCallState) -> bool:
        exc = retry_state.outcome.exception() if retry_state.outcome else None
        if isinstance(exc, httpx.HTTPStatusError):
            return exc.response.status_code >= 500
        return isinstance(exc, RETRYABLE_EXCEPTIONS)


def with_retry(
    max_attempts: int = 3,
    min_wait: int = 1,
    max_wait: int = 5,
) -> Callable[[_F], _F]:
    """Decorate an async function with tenacity retry logic.

    Retries on ``httpx.ConnectError``, ``TimeoutException``, and HTTP 5xx
    errors with exponential backoff. 4xx errors are not retried.
    """
    return retry(
        stop=stop_after_attempt(max_attempts),
        wait=wait_exponential(multiplier=1, min=min_wait, max=max_wait),
        retry=_retry_if_server_error(),
        reraise=True,
    )


async def with_timeout(coro: Any, timeout_seconds: float) -> Any:
    """Run *coro* with an ``asyncio.wait_for`` timeout wrapper.

    Raises ``asyncio.TimeoutError`` if the coroutine does not complete
    within *timeout_seconds*.
    """
    return await asyncio.wait_for(coro, timeout=timeout_seconds)
