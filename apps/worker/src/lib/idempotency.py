"""In-memory idempotency store for deduplicating task executions."""

import hashlib
import json
import time
from typing import Any

_DEFAULT_TTL = 3600  # 1 hour


class _IdempotencyStore:
    """Simple in-memory store with TTL-based expiry."""

    def __init__(self) -> None:
        self._store: dict[str, float] = {}

    def _make_key(
        self,
        task_type: str,
        data: dict[str, Any],
        *,
        idempotency_key: str | None = None,
    ) -> str:
        if idempotency_key:
            return f"{task_type}:{idempotency_key}"
        raw = json.dumps(data, sort_keys=True, default=str)
        digest = hashlib.sha256(raw.encode()).hexdigest()[:16]
        return f"{task_type}:{digest}"

    def _evict_expired(self) -> None:
        now = time.monotonic()
        expired = [k for k, v in self._store.items() if v < now]
        for k in expired:
            del self._store[k]

    def is_duplicate(
        self,
        task_type: str,
        data: dict[str, Any],
        *,
        idempotency_key: str | None = None,
    ) -> bool:
        """Check if this task has already been processed."""
        self._evict_expired()
        key = self._make_key(task_type, data, idempotency_key=idempotency_key)
        return key in self._store

    def mark_processed(
        self,
        task_type: str,
        data: dict[str, Any],
        *,
        idempotency_key: str | None = None,
        ttl: int = _DEFAULT_TTL,
    ) -> None:
        """Mark a task as processed with TTL."""
        key = self._make_key(task_type, data, idempotency_key=idempotency_key)
        self._store[key] = time.monotonic() + ttl

    def clear(self) -> None:
        """Clear all entries (for testing)."""
        self._store.clear()


_store = _IdempotencyStore()

is_duplicate = _store.is_duplicate
mark_processed = _store.mark_processed
clear = _store.clear
