"""Tests for the Pub/Sub push router."""

from __future__ import annotations

import base64
import json
from unittest.mock import AsyncMock, MagicMock, patch

import pytest
from fastapi.testclient import TestClient

from src.lib.idempotency import clear as clear_idempotency
from src.main import app

JOBS_BASE = "src.jobs.base"


@pytest.fixture
def client() -> TestClient:
    return TestClient(app)


class TestPubSubRouter:
    def _envelope(
        self,
        task_type: str,
        data: dict[str, object] | None = None,
    ) -> dict[str, object]:
        payload = json.dumps({"task_type": task_type, "data": data or {}})
        encoded = base64.b64encode(payload.encode()).decode()
        return {
            "message": {"data": encoded, "attributes": {}, "messageId": "msg-1"},
            "subscription": "projects/p/subscriptions/s",
        }

    @patch(f"{JOBS_BASE}.get_job")
    def test_dispatch_success(
        self, mock_get_job: MagicMock, client: TestClient
    ) -> None:
        mock_job = AsyncMock()
        mock_job.execute.return_value = {"sent_count": 1}
        mock_get_job.return_value = mock_job

        response = client.post(
            "/tasks/pubsub",
            json=self._envelope("notification.send", {"tokens": ["t1"]}),
        )
        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "completed"
        assert data["sent_count"] == 1

    @patch(f"{JOBS_BASE}.get_job", return_value=None)
    def test_unknown_job_400(self, mock_get_job: MagicMock, client: TestClient) -> None:
        response = client.post(
            "/tasks/pubsub",
            json=self._envelope("nonexistent.job"),
        )
        assert response.status_code == 400
        assert "Unknown job type" in response.json()["detail"]

    def test_invalid_base64_400(self, client: TestClient) -> None:
        response = client.post(
            "/tasks/pubsub",
            json={
                "message": {
                    "data": "!!!not-base64!!!",
                    "attributes": {},
                    "messageId": "x",
                },
                "subscription": "",
            },
        )
        assert response.status_code == 400

    def test_invalid_json_400(self, client: TestClient) -> None:
        encoded = base64.b64encode(b"not-json").decode()
        response = client.post(
            "/tasks/pubsub",
            json={
                "message": {"data": encoded, "attributes": {}, "messageId": "x"},
                "subscription": "",
            },
        )
        assert response.status_code == 400

    def test_missing_task_type_400(self, client: TestClient) -> None:
        payload = json.dumps({"data": {}})
        encoded = base64.b64encode(payload.encode()).decode()
        response = client.post(
            "/tasks/pubsub",
            json={
                "message": {"data": encoded, "attributes": {}, "messageId": "x"},
                "subscription": "",
            },
        )
        assert response.status_code == 400
        assert "Missing task_type" in response.json()["detail"]

    @patch(f"{JOBS_BASE}.get_job")
    def test_duplicate_message_id_returns_duplicate(
        self, mock_get_job: MagicMock, client: TestClient
    ) -> None:
        clear_idempotency()
        mock_job = AsyncMock()
        mock_job.execute.return_value = {"sent_count": 1}
        mock_get_job.return_value = mock_job

        envelope = self._envelope("notification.send", {"tokens": ["t1"]})

        first = client.post("/tasks/pubsub", json=envelope)
        assert first.status_code == 200
        assert first.json()["status"] == "completed"

        second = client.post("/tasks/pubsub", json=envelope)
        assert second.status_code == 200
        assert second.json()["status"] == "duplicate"
