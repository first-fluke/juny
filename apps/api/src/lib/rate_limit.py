"""Rate limiting middleware with Redis or in-memory backend."""

from __future__ import annotations

import functools
import time
from collections.abc import Awaitable, Callable
from dataclasses import dataclass, field
from typing import TYPE_CHECKING, Any, cast

from fastapi import HTTPException, Request, status
from fastapi.responses import JSONResponse, Response

from src.lib.config import settings
from src.lib.logging import get_logger

if TYPE_CHECKING:
    import redis.asyncio as redis_module

logger = get_logger(__name__)


@dataclass
class RateLimitConfig:
    """Rate limit configuration."""

    requests: int = 100  # Number of requests
    window: int = 60  # Time window in seconds
    key_func: Callable[[Request], str] | None = None  # Custom key function


def default_key_func(request: Request) -> str:
    """Default rate limit key: IP address + path."""
    forwarded = request.headers.get("X-Forwarded-For")
    if forwarded:
        ip = forwarded.split(",")[0].strip()
    else:
        ip = request.client.host if request.client else "unknown"
    return f"{ip}:{request.url.path}"


@dataclass
class InMemoryRateLimiter:
    """Simple in-memory rate limiter using sliding window."""

    requests: int
    window: int
    _storage: dict[str, list[float]] = field(default_factory=dict)

    def is_allowed(self, key: str) -> tuple[bool, int, int]:
        """
        Check if request is allowed.

        Returns:
            tuple: (allowed, remaining, reset_after)
        """
        now = time.time()
        window_start = now - self.window

        # Clean old entries
        entries = [ts for ts in self._storage.get(key, []) if ts > window_start]

        current_count = len(entries)
        remaining = max(0, self.requests - current_count - 1)
        reset_after = int(self.window - (now - entries[0])) if entries else self.window

        if current_count >= self.requests:
            self._storage[key] = entries
            return False, 0, reset_after

        entries.append(now)
        self._storage[key] = entries
        return True, remaining, reset_after


_LUA_SLIDING_WINDOW = """
local key = KEYS[1]
local now = tonumber(ARGV[1])
local window = tonumber(ARGV[2])
local limit = tonumber(ARGV[3])
local member = ARGV[4]

redis.call('ZREMRANGEBYSCORE', key, 0, now - window)
local count = redis.call('ZCARD', key)
if count < limit then
    redis.call('ZADD', key, now, member)
    redis.call('EXPIRE', key, window)
    return 1
end
return 0
"""


class RedisRateLimiter:
    """Redis-based rate limiter using atomic Lua sliding window."""

    def __init__(self, requests: int, window: int):
        self.requests = requests
        self.window = window
        self._redis: redis_module.Redis | None = None
        self._script: Any = None

    async def _get_redis(self) -> redis_module.Redis:
        """Lazy Redis connection."""
        if self._redis is None:
            import redis.asyncio as redis

            self._redis = redis.from_url(settings.REDIS_URL)  # type: ignore[no-untyped-call]
            self._script = self._redis.register_script(_LUA_SLIDING_WINDOW)
        return self._redis

    async def is_allowed(self, key: str) -> tuple[bool, int, int]:
        """
        Check if request is allowed using atomic Lua script.

        Returns:
            tuple: (allowed, remaining, reset_after)
        """
        redis = await self._get_redis()
        now = time.time()
        rate_key = f"rate_limit:{key}"
        member = f"{now}"

        allowed_int: int = await self._script(
            keys=[rate_key],
            args=[now, self.window, self.requests, member],
            client=redis,
        )

        if allowed_int == 1:
            # Count after add
            count = await redis.zcard(rate_key)
            remaining = max(0, self.requests - count)
            return True, remaining, self.window

        return False, 0, self.window

    async def close(self) -> None:
        """Close Redis connection."""
        if self._redis:
            await self._redis.aclose()
            self._redis = None


# Config-keyed rate limiter instances
_rate_limiters: dict[tuple[int, int], InMemoryRateLimiter | RedisRateLimiter] = {}


def reset_rate_limiters() -> None:
    """Reset all rate limiter instances (useful for testing)."""
    _rate_limiters.clear()


async def close_rate_limiters() -> None:
    """Close all rate limiter connections and reset registry."""
    for limiter in _rate_limiters.values():
        if isinstance(limiter, RedisRateLimiter):
            await limiter.close()
    _rate_limiters.clear()


def get_rate_limiter(config: RateLimitConfig) -> InMemoryRateLimiter | RedisRateLimiter:
    """Get or create rate limiter instance per (requests, window) config."""
    key = (config.requests, config.window)

    if key not in _rate_limiters:
        if settings.REDIS_URL:
            logger.info(
                "Creating Redis rate limiter",
                requests=config.requests,
                window=config.window,
            )
            _rate_limiters[key] = RedisRateLimiter(config.requests, config.window)
        else:
            logger.info(
                "Creating in-memory rate limiter",
                requests=config.requests,
                window=config.window,
            )
            _rate_limiters[key] = InMemoryRateLimiter(config.requests, config.window)

    return _rate_limiters[key]


def rate_limit(
    requests: int = 100,
    window: int = 60,
    key_func: Callable[[Request], str] | None = None,
) -> Callable[..., Any]:
    """
    Rate limit decorator for FastAPI endpoints.

    Args:
        requests: Maximum requests allowed in the window
        window: Time window in seconds
        key_func: Custom function to generate rate limit key

    Usage:
        @app.get("/api/resource")
        @rate_limit(requests=10, window=60)
        async def get_resource():
            ...
    """
    config = RateLimitConfig(requests=requests, window=window, key_func=key_func)
    actual_key_func = key_func or default_key_func

    def decorator(
        func: Callable[..., Awaitable[Response]],
    ) -> Callable[..., Awaitable[Response]]:
        @functools.wraps(func)
        async def wrapper(*args: object, **kwargs: object) -> Response:
            # Find request in args/kwargs
            request: Request | None = None
            for arg in args:
                if isinstance(arg, Request):
                    request = arg
                    break
            if request is None:
                request = cast(Request | None, kwargs.get("request"))

            if request is None:
                return await func(*args, **kwargs)

            limiter = get_rate_limiter(config)
            key = actual_key_func(request)

            if isinstance(limiter, RedisRateLimiter):
                allowed, _remaining, reset_after = await limiter.is_allowed(key)
            else:
                allowed, _remaining, reset_after = limiter.is_allowed(key)

            if not allowed:
                logger.warning("Rate limit exceeded", key=key)
                raise HTTPException(
                    status_code=status.HTTP_429_TOO_MANY_REQUESTS,
                    detail="Rate limit exceeded",
                    headers={
                        "X-RateLimit-Limit": str(config.requests),
                        "X-RateLimit-Remaining": "0",
                        "X-RateLimit-Reset": str(reset_after),
                        "Retry-After": str(reset_after),
                    },
                )

            return await func(*args, **kwargs)

        return wrapper

    return decorator


async def rate_limit_middleware(
    request: Request,
    call_next: Callable[[Request], Awaitable[Response]],
    config: RateLimitConfig | None = None,
) -> Response:
    """
    Rate limit middleware for global application.

    Usage in main.py:
        @app.middleware("http")
        async def rate_limit_mw(request: Request, call_next):
            return await rate_limit_middleware(request, call_next)
    """
    if config is None:
        config = RateLimitConfig()

    # Skip rate limiting for health and admin endpoints
    path = request.url.path
    if path.startswith("/health") or path.startswith("/api/v1/admin"):
        return await call_next(request)

    key_func = config.key_func or default_key_func
    limiter = get_rate_limiter(config)
    key = key_func(request)

    if isinstance(limiter, RedisRateLimiter):
        allowed, remaining, reset_after = await limiter.is_allowed(key)
    else:
        allowed, remaining, reset_after = limiter.is_allowed(key)

    if not allowed:
        logger.warning("Rate limit exceeded", key=key, path=request.url.path)
        return JSONResponse(
            status_code=status.HTTP_429_TOO_MANY_REQUESTS,
            content={"detail": "Rate limit exceeded"},
            headers={
                "X-RateLimit-Limit": str(config.requests),
                "X-RateLimit-Remaining": "0",
                "X-RateLimit-Reset": str(reset_after),
                "Retry-After": str(reset_after),
            },
        )

    response = await call_next(request)
    response.headers["X-RateLimit-Limit"] = str(config.requests)
    response.headers["X-RateLimit-Remaining"] = str(remaining)
    response.headers["X-RateLimit-Reset"] = str(reset_after)
    return response
