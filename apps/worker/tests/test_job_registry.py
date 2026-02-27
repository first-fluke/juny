"""Tests for the job registry and auto-discovery."""

from __future__ import annotations

from typing import Any

import pytest

from src.jobs.base import BaseJob, get_job, list_jobs, register_job


class DummyJob(BaseJob):
    @property
    def job_type(self) -> str:
        return "test.dummy"

    async def execute(self, data: dict[str, Any]) -> dict[str, Any]:
        return {"echo": data}


class TestJobRegistry:
    def test_register_and_get(self) -> None:
        job = DummyJob()
        register_job(job)
        assert get_job("test.dummy") is job

    def test_get_nonexistent(self) -> None:
        assert get_job("nonexistent.job") is None

    def test_list_jobs_contains_registered(self) -> None:
        register_job(DummyJob())
        jobs = list_jobs()
        assert "test.dummy" in jobs

    @pytest.mark.asyncio
    async def test_dummy_job_execute(self) -> None:
        job = DummyJob()
        result = await job.execute({"key": "value"})
        assert result == {"echo": {"key": "value"}}


class TestAutoDiscovery:
    def test_jobs_auto_discovered(self) -> None:
        """Verify that importing src.jobs triggers registration."""
        import src.jobs  # noqa: F401

        jobs = list_jobs()
        expected = [
            "notification.send",
            "medication.reminder",
            "wellness.aggregate",
            "data.cleanup",
            "relation.inactive_check",
            "wellness.escalation",
        ]
        for job_type in expected:
            assert job_type in jobs, f"{job_type} not registered"
