"""Redis cache utilities with graceful fallback."""

import functools
import hashlib
import json
from collections.abc import Callable
from typing import Any, TypeVar

import structlog

from src.lib.config import settings

logger = structlog.get_logger(__name__)

_F = TypeVar("_F", bound=Callable[..., Any])


async def _get_redis() -> Any:
    """Get a Redis client, or None if not configured."""
    if not settings.REDIS_URL:
        return None
    import redis.asyncio as aioredis

    return aioredis.from_url(settings.REDIS_URL)  # type: ignore[no-untyped-call]


async def cache_get(key: str) -> Any | None:
    """Get a value from cache. Returns None on miss or if Redis is unavailable."""
    client = await _get_redis()
    if client is None:
        return None
    try:
        raw = await client.get(key)
        await client.aclose()
        if raw is None:
            return None
        return json.loads(raw)
    except Exception:
        logger.warning("cache_get_error", key=key)
        return None


async def cache_set(key: str, value: Any, ttl: int = 300) -> None:
    """Set a value in cache with TTL (seconds). No-op if Redis is unavailable."""
    client = await _get_redis()
    if client is None:
        return
    try:
        await client.setex(key, ttl, json.dumps(value))
        await client.aclose()
    except Exception:
        logger.warning("cache_set_error", key=key)


async def cache_delete(key: str) -> None:
    """Delete a key from cache. No-op if Redis is unavailable."""
    client = await _get_redis()
    if client is None:
        return
    try:
        await client.delete(key)
        await client.aclose()
    except Exception:
        logger.warning("cache_delete_error", key=key)


def cached(prefix: str, ttl: int = 300) -> Callable[[_F], _F]:
    """Decorator to cache async function results.

    Cache key is built from ``prefix`` + hash of arguments.
    Falls back to executing the function directly when Redis is unavailable.
    """

    def decorator(func: _F) -> _F:
        @functools.wraps(func)
        async def wrapper(*args: Any, **kwargs: Any) -> Any:
            raw_key = json.dumps(
                {"args": [str(a) for a in args], "kwargs": kwargs},
                sort_keys=True,
                default=str,
            )
            key = f"{prefix}:{hashlib.sha256(raw_key.encode()).hexdigest()[:16]}"

            hit = await cache_get(key)
            if hit is not None:
                return hit

            result = await func(*args, **kwargs)
            await cache_set(key, result, ttl)
            return result

        return wrapper  # type: ignore[return-value]

    return decorator
