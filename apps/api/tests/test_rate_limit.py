"""Tests for rate limiting: middleware, decorator, per-endpoint limits."""

from unittest.mock import AsyncMock, patch

import pytest
from fastapi import Request
from fastapi.testclient import TestClient

from src.admin.schemas import CleanupResponse
from src.lib.rate_limit import (
    InMemoryRateLimiter,
    RateLimitConfig,
    default_key_func,
    get_rate_limiter,
    reset_rate_limiters,
)

pytestmark = [
    pytest.mark.filterwarnings("ignore::jwt.warnings.InsecureKeyLengthWarning"),
]


# ── InMemoryRateLimiter unit tests ──────────────────────────────


class TestInMemoryRateLimiter:
    def test_allows_under_limit(self) -> None:
        limiter = InMemoryRateLimiter(requests=5, window=60)
        allowed, remaining, _ = limiter.is_allowed("key1")
        assert allowed is True
        assert remaining == 4

    def test_blocks_over_limit(self) -> None:
        limiter = InMemoryRateLimiter(requests=3, window=60)
        for _ in range(3):
            limiter.is_allowed("key1")
        allowed, remaining, _ = limiter.is_allowed("key1")
        assert allowed is False
        assert remaining == 0

    def test_different_keys_independent(self) -> None:
        limiter = InMemoryRateLimiter(requests=2, window=60)
        for _ in range(2):
            limiter.is_allowed("key_a")
        # key_a exhausted
        allowed_a, _, _ = limiter.is_allowed("key_a")
        assert allowed_a is False
        # key_b still has quota
        allowed_b, remaining_b, _ = limiter.is_allowed("key_b")
        assert allowed_b is True
        assert remaining_b == 1


# ── Config-keyed limiter registry ───────────────────────────────


class TestGetRateLimiter:
    @patch("src.lib.rate_limit.settings")
    def test_returns_in_memory_when_no_redis(self, mock_settings: object) -> None:
        mock_settings.REDIS_URL = None  # type: ignore[attr-defined]
        reset_rate_limiters()
        config = RateLimitConfig(requests=10, window=60)
        limiter = get_rate_limiter(config)
        assert isinstance(limiter, InMemoryRateLimiter)

    def test_same_config_returns_same_instance(self) -> None:
        reset_rate_limiters()
        config_a = RateLimitConfig(requests=10, window=60)
        config_b = RateLimitConfig(requests=10, window=60)
        assert get_rate_limiter(config_a) is get_rate_limiter(config_b)

    def test_different_config_returns_different_instance(self) -> None:
        reset_rate_limiters()
        config_a = RateLimitConfig(requests=10, window=60)
        config_b = RateLimitConfig(requests=20, window=60)
        assert get_rate_limiter(config_a) is not get_rate_limiter(config_b)


# ── Middleware tests ────────────────────────────────────────────


class TestRateLimitMiddleware:
    def test_health_endpoint_skips_rate_limit(self, client: TestClient) -> None:
        """/health is skipped by middleware — no rate limit headers."""
        resp = client.get("/health")
        assert "X-RateLimit-Limit" not in resp.headers

    def test_logout_endpoint_gets_rate_limit_headers(self, client: TestClient) -> None:
        """Non-skipped endpoints should get rate limit headers."""
        # POST /logout doesn't need DB — safe to call in unit tests
        resp = client.post("/api/v1/auth/logout")
        assert resp.status_code == 204
        assert "X-RateLimit-Limit" in resp.headers
        assert resp.headers["X-RateLimit-Limit"] == "100"

    @patch("src.admin.service.cleanup_data")
    def test_admin_endpoints_skip_rate_limit(
        self, mock_cleanup: AsyncMock, client: TestClient
    ) -> None:
        """Admin endpoints should bypass rate limiting."""
        mock_cleanup.return_value = CleanupResponse(
            deleted_wellness_logs=0, deactivated_tokens=0
        )
        resp = client.post(
            "/api/v1/admin/cleanup",
            json={"retention_days": 90},
        )
        assert resp.status_code == 200
        assert "X-RateLimit-Limit" not in resp.headers


# ── Decorator tests ─────────────────────────────────────────────


class TestRateLimitDecorator:
    def test_login_rate_limit_decorator_preserves_validation(
        self, client: TestClient
    ) -> None:
        """login endpoint has rate_limit(10, 60) — decorator doesn't break FastAPI."""
        resp = client.post("/api/v1/auth/login", json={})
        assert resp.status_code == 422

    def test_refresh_rate_limit_decorator_preserves_validation(
        self, client: TestClient
    ) -> None:
        """refresh endpoint has rate_limit(20, 60) — decorator doesn't break FastAPI."""
        resp = client.post("/api/v1/auth/refresh", json={})
        assert resp.status_code == 422


# ── default_key_func ────────────────────────────────────────────


class TestDefaultKeyFunc:
    def test_uses_forwarded_for(self) -> None:
        mock_request = AsyncMock(spec=Request)
        mock_request.headers = {"X-Forwarded-For": "1.2.3.4, 5.6.7.8"}
        mock_request.url.path = "/test"
        key = default_key_func(mock_request)
        assert key == "1.2.3.4:/test"

    def test_uses_client_host(self) -> None:
        mock_request = AsyncMock(spec=Request)
        mock_request.headers = {}
        mock_request.client.host = "127.0.0.1"
        mock_request.url.path = "/api"
        key = default_key_func(mock_request)
        assert key == "127.0.0.1:/api"
