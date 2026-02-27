"""Tests for the task_client dispatch utility."""

from __future__ import annotations

import sys
from unittest.mock import AsyncMock, MagicMock, patch

import pytest

from src.lib.task_client import dispatch_task


class TestDispatchTask:
    @pytest.mark.asyncio
    @patch("src.lib.task_client.settings")
    @patch("src.lib.task_client.httpx.AsyncClient")
    async def test_local_dispatch(
        self,
        mock_client_cls: AsyncMock,
        mock_settings: AsyncMock,
    ) -> None:
        mock_settings.PROJECT_ENV = "local"
        mock_settings.WORKER_URL = "http://localhost:8280"

        mock_client = AsyncMock()
        mock_client_cls.return_value.__aenter__ = AsyncMock(return_value=mock_client)
        mock_client_cls.return_value.__aexit__ = AsyncMock(return_value=None)
        mock_response = AsyncMock()
        mock_response.status_code = 200
        mock_client.post.return_value = mock_response

        await dispatch_task("notification.send", {"tokens": ["t1"]})
        mock_client.post.assert_called_once()
        call_args = mock_client.post.call_args
        assert "notification.send" in str(call_args)

    @pytest.mark.asyncio
    @patch("src.lib.task_client.settings")
    async def test_cloud_tasks_dispatch(self, mock_settings: AsyncMock) -> None:
        mock_settings.PROJECT_ENV = "staging"
        mock_settings.WORKER_URL = "https://worker.example.com"
        mock_settings.GOOGLE_CLOUD_PROJECT = "my-project"
        mock_settings.CLOUD_TASKS_LOCATION = "asia-northeast3"
        mock_settings.CLOUD_TASKS_QUEUE = "default"

        # Mock google.cloud.tasks_v2 (optional dep, imported in-function)
        mock_tasks_v2 = MagicMock()
        mock_client_instance = MagicMock()
        mock_tasks_v2.CloudTasksClient.return_value = mock_client_instance
        mock_client_instance.queue_path.return_value = (
            "projects/my-project/locations/an3/queues/default"
        )
        mock_client_instance.create_task.return_value = MagicMock(name="task-001")

        # from google.cloud import tasks_v2 resolves via google.cloud attr
        mock_gc = MagicMock()
        mock_gc.tasks_v2 = mock_tasks_v2

        with patch.dict(
            sys.modules,
            {
                "google": MagicMock(),
                "google.cloud": mock_gc,
                "google.cloud.tasks_v2": mock_tasks_v2,
            },
        ):
            await dispatch_task("wellness.aggregate", {"host_id": "abc"})
            mock_client_instance.create_task.assert_called_once()
