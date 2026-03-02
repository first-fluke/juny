"""Tests for idempotency module."""

from __future__ import annotations

import time
from unittest.mock import patch

from src.lib.idempotency import (
    clear,
    is_duplicate,
    mark_processed,
    release_claim,
    try_claim,
)


class TestIdempotency:
    def setup_method(self) -> None:
        clear()

    def test_new_task_is_not_duplicate(self) -> None:
        assert is_duplicate("send_notification", {"user": "abc"}) is False

    def test_processed_task_is_duplicate(self) -> None:
        data = {"user": "abc"}
        mark_processed("send_notification", data)
        assert is_duplicate("send_notification", data) is True

    def test_different_data_is_not_duplicate(self) -> None:
        mark_processed("send_notification", {"user": "abc"})
        assert is_duplicate("send_notification", {"user": "xyz"}) is False

    def test_different_task_type_is_not_duplicate(self) -> None:
        mark_processed("send_notification", {"user": "abc"})
        assert is_duplicate("cleanup", {"user": "abc"}) is False

    def test_idempotency_key_overrides_data_hash(self) -> None:
        mark_processed(
            "send_notification",
            {"a": 1},
            idempotency_key="msg-123",
        )
        # Same idempotency key, different data
        assert (
            is_duplicate(
                "send_notification",
                {"b": 2},
                idempotency_key="msg-123",
            )
            is True
        )

    def test_expired_entry_is_not_duplicate(self) -> None:
        mark_processed("send_notification", {"user": "abc"}, ttl=0)
        # Simulate time passing
        with patch("src.lib.idempotency.time") as mock_time:
            mock_time.monotonic.return_value = time.monotonic() + 1
            assert is_duplicate("send_notification", {"user": "abc"}) is False

    def test_clear_removes_all_entries(self) -> None:
        mark_processed("send_notification", {"user": "abc"})
        clear()
        assert is_duplicate("send_notification", {"user": "abc"}) is False


class TestTryClaim:
    def setup_method(self) -> None:
        clear()

    def test_first_claim_returns_true(self) -> None:
        assert try_claim("send_notification", {"user": "abc"}) is True

    def test_second_claim_returns_false(self) -> None:
        try_claim("send_notification", {"user": "abc"})
        assert try_claim("send_notification", {"user": "abc"}) is False

    def test_claim_with_idempotency_key(self) -> None:
        claimed = try_claim("send_notification", {"a": 1}, idempotency_key="msg-1")
        assert claimed is True
        dup = try_claim("send_notification", {"b": 2}, idempotency_key="msg-1")
        assert dup is False

    def test_expired_claim_can_be_reclaimed(self) -> None:
        try_claim("send_notification", {"user": "abc"}, ttl=0)
        with patch("src.lib.idempotency.time") as mock_time:
            mock_time.monotonic.return_value = time.monotonic() + 1
            assert try_claim("send_notification", {"user": "abc"}) is True

    def test_release_claim_allows_retry(self) -> None:
        try_claim("send_notification", {"user": "abc"})
        assert try_claim("send_notification", {"user": "abc"}) is False
        release_claim("send_notification", {"user": "abc"})
        assert try_claim("send_notification", {"user": "abc"}) is True

    def test_release_claim_with_idempotency_key(self) -> None:
        try_claim("send_notification", {"a": 1}, idempotency_key="k1")
        release_claim("send_notification", {"a": 1}, idempotency_key="k1")
        reclaimed = try_claim("send_notification", {"a": 1}, idempotency_key="k1")
        assert reclaimed is True

    def test_release_claim_nonexistent_is_noop(self) -> None:
        release_claim("send_notification", {"no": "entry"})  # no error


class TestMaxSizeEnforcement:
    def setup_method(self) -> None:
        clear()

    @patch("src.lib.idempotency._MAX_SIZE", 10)
    def test_evicts_oldest_when_max_size_exceeded(self) -> None:
        # Fill to capacity
        for i in range(10):
            mark_processed("job", {"i": i}, ttl=9999)

        # The 11th entry should trigger eviction of oldest
        mark_processed("job", {"i": 10}, ttl=9999)

        # After eviction of 10% (1 entry), oldest should be gone
        assert is_duplicate("job", {"i": 0}) is False
        # Newer entries should still be present
        assert is_duplicate("job", {"i": 10}) is True

    @patch("src.lib.idempotency._MAX_SIZE", 10)
    def test_try_claim_enforces_max_size(self) -> None:
        for i in range(10):
            try_claim("job", {"i": i}, ttl=9999)

        # 11th claim triggers eviction
        assert try_claim("job", {"i": 10}) is True
        assert is_duplicate("job", {"i": 0}) is False
