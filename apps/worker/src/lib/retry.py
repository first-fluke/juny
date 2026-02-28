from collections.abc import Callable
from typing import TypeVar

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
    min_wait: int = 2,
    max_wait: int = 10,
) -> Callable[[_F], _F]:
    """Decorate an async method with tenacity retry logic."""
    return retry(
        stop=stop_after_attempt(max_attempts),
        wait=wait_exponential(multiplier=1, min=min_wait, max=max_wait),
        retry=retry_if_exception_type(RETRYABLE_EXCEPTIONS),
        reraise=True,
    )
