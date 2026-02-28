from __future__ import annotations

from unittest.mock import AsyncMock, patch

import pytest

from src.lib.cache import cache_delete, cache_get, cache_set, cached

_CACHE = "src.lib.cache"


class TestCacheGet:
    @pytest.mark.asyncio
    @patch(f"{_CACHE}._get_redis", new_callable=AsyncMock)
    async def test_cache_hit(self, mock_redis: AsyncMock) -> None:
        client = AsyncMock()
        client.get = AsyncMock(return_value=b'{"value": 42}')
        mock_redis.return_value = client

        result = await cache_get("my-key")
        assert result == {"value": 42}
        client.get.assert_called_once_with("my-key")
        client.aclose.assert_called_once()

    @pytest.mark.asyncio
    @patch(f"{_CACHE}._get_redis", new_callable=AsyncMock)
    async def test_cache_miss(self, mock_redis: AsyncMock) -> None:
        client = AsyncMock()
        client.get = AsyncMock(return_value=None)
        mock_redis.return_value = client

        result = await cache_get("missing-key")
        assert result is None

    @pytest.mark.asyncio
    @patch(f"{_CACHE}._get_redis", new_callable=AsyncMock)
    async def test_cache_no_redis(self, mock_redis: AsyncMock) -> None:
        mock_redis.return_value = None
        result = await cache_get("any-key")
        assert result is None

    @pytest.mark.asyncio
    @patch(f"{_CACHE}._get_redis", new_callable=AsyncMock)
    async def test_cache_error_returns_none(self, mock_redis: AsyncMock) -> None:
        client = AsyncMock()
        client.get = AsyncMock(side_effect=Exception("Redis down"))
        mock_redis.return_value = client

        result = await cache_get("error-key")
        assert result is None


class TestCacheSet:
    @pytest.mark.asyncio
    @patch(f"{_CACHE}._get_redis", new_callable=AsyncMock)
    async def test_cache_set(self, mock_redis: AsyncMock) -> None:
        client = AsyncMock()
        mock_redis.return_value = client

        await cache_set("key", {"data": 1}, ttl=60)
        client.setex.assert_called_once()
        client.aclose.assert_called_once()

    @pytest.mark.asyncio
    @patch(f"{_CACHE}._get_redis", new_callable=AsyncMock)
    async def test_cache_set_no_redis(self, mock_redis: AsyncMock) -> None:
        mock_redis.return_value = None
        await cache_set("key", {"data": 1})
        # No error raised


class TestCacheDelete:
    @pytest.mark.asyncio
    @patch(f"{_CACHE}._get_redis", new_callable=AsyncMock)
    async def test_cache_delete(self, mock_redis: AsyncMock) -> None:
        client = AsyncMock()
        mock_redis.return_value = client

        await cache_delete("key")
        client.delete.assert_called_once_with("key")
        client.aclose.assert_called_once()


class TestCachedDecorator:
    @pytest.mark.asyncio
    @patch(f"{_CACHE}.cache_set", new_callable=AsyncMock)
    @patch(f"{_CACHE}.cache_get", new_callable=AsyncMock)
    async def test_cache_miss_calls_function(
        self, mock_get: AsyncMock, mock_set: AsyncMock
    ) -> None:
        mock_get.return_value = None

        @cached("test", ttl=60)
        async def my_func(x: int) -> int:
            return x * 2

        result = await my_func(5)
        assert result == 10
        mock_get.assert_called_once()
        mock_set.assert_called_once()

    @pytest.mark.asyncio
    @patch(f"{_CACHE}.cache_set", new_callable=AsyncMock)
    @patch(f"{_CACHE}.cache_get", new_callable=AsyncMock)
    async def test_cache_hit_returns_cached(
        self, mock_get: AsyncMock, mock_set: AsyncMock
    ) -> None:
        mock_get.return_value = {"cached": True}

        call_count = 0

        @cached("test", ttl=60)
        async def my_func() -> dict[str, bool]:
            nonlocal call_count
            call_count += 1
            return {"cached": False}

        result = await my_func()
        assert result == {"cached": True}
        assert call_count == 0
        mock_set.assert_not_called()
