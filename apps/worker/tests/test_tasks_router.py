"""Integration tests for the /tasks router."""

from __future__ import annotations

from typing import TYPE_CHECKING

from src.lib.idempotency import clear as clear_idempotency

if TYPE_CHECKING:
    from fastapi.testclient import TestClient


class TestTasksRouter:
    def setup_method(self) -> None:
        clear_idempotency()

    def test_process_known_job(self, client: TestClient) -> None:
        """notification.send with mock provider should succeed."""
        response = client.post(
            "/tasks/process",
            json={
                "task_type": "notification.send",
                "data": {"tokens": ["tok-1"], "title": "T", "body": "B"},
            },
        )
        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "completed"

    def test_process_unknown_job(self, client: TestClient) -> None:
        response = client.post(
            "/tasks/process",
            json={"task_type": "does.not.exist", "data": {}},
        )
        assert response.status_code == 400
        assert "Unknown job type" in response.json()["detail"]

    def test_list_jobs(self, client: TestClient) -> None:
        response = client.get("/tasks/jobs")
        assert response.status_code == 200
        data = response.json()
        assert "notification.send" in data["job_types"]

    def test_duplicate_returns_duplicate_status(self, client: TestClient) -> None:
        payload = {
            "task_type": "notification.send",
            "data": {"tokens": ["tok-dup"], "title": "T", "body": "B"},
        }
        first = client.post("/tasks/process", json=payload)
        assert first.status_code == 200
        assert first.json()["status"] == "completed"

        second = client.post("/tasks/process", json=payload)
        assert second.status_code == 200
        assert second.json()["status"] == "duplicate"
