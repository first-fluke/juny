"""Tests for the files router (upload, get, delete + authorization)."""

from __future__ import annotations

from collections.abc import AsyncGenerator, Generator
from io import BytesIO
from typing import TYPE_CHECKING
from unittest.mock import AsyncMock

import pytest

from src.lib.database import get_db
from src.lib.dependencies import get_storage
from src.main import app

if TYPE_CHECKING:
    from fastapi.testclient import TestClient

TEST_USER_ID = "00000000-0000-4000-8000-000000000099"
OTHER_USER_ID = "00000000-0000-4000-8000-000000000070"


@pytest.fixture
def mock_storage() -> AsyncMock:
    """Create a mock storage provider."""
    storage = AsyncMock()
    storage.upload.return_value = "test-key"
    storage.get_signed_url.return_value = "https://signed.url/test"
    storage.delete.return_value = None
    return storage


class TestFileUpload:
    @pytest.fixture(autouse=True)
    def _setup(self, mock_storage: AsyncMock) -> Generator[None, None, None]:
        async def _db_override() -> AsyncGenerator[AsyncMock, None]:
            yield AsyncMock()

        app.dependency_overrides[get_db] = _db_override
        app.dependency_overrides[get_storage] = lambda: mock_storage
        yield
        app.dependency_overrides.clear()

    def test_upload_success(
        self,
        authed_client: TestClient,
        mock_storage: AsyncMock,
    ) -> None:
        file = BytesIO(b"hello world")
        response = authed_client.post(
            "/api/v1/files/upload",
            files={"file": ("test.txt", file, "text/plain")},
        )
        assert response.status_code == 201
        data = response.json()
        assert data["key"].startswith(TEST_USER_ID)
        assert data["content_type"] == "text/plain"
        assert data["size"] == 11
        mock_storage.upload.assert_called_once()

    def test_upload_too_large(self, authed_client: TestClient) -> None:
        large_data = b"x" * (10 * 1024 * 1024 + 1)
        file = BytesIO(large_data)
        response = authed_client.post(
            "/api/v1/files/upload",
            files={"file": ("big.bin", file, "application/octet-stream")},
        )
        assert response.status_code == 413


class TestFileGet:
    @pytest.fixture(autouse=True)
    def _setup(self, mock_storage: AsyncMock) -> Generator[None, None, None]:
        async def _db_override() -> AsyncGenerator[AsyncMock, None]:
            yield AsyncMock()

        app.dependency_overrides[get_db] = _db_override
        app.dependency_overrides[get_storage] = lambda: mock_storage
        yield
        app.dependency_overrides.clear()

    def test_get_own_file(
        self,
        authed_client: TestClient,
        mock_storage: AsyncMock,
    ) -> None:
        key = f"{TEST_USER_ID}/abc.txt"
        response = authed_client.get(
            f"/api/v1/files/{key}",
            follow_redirects=False,
        )
        assert response.status_code == 307
        mock_storage.get_signed_url.assert_called_once()

    def test_get_other_user_file_403(self, authed_client: TestClient) -> None:
        key = f"{OTHER_USER_ID}/abc.txt"
        response = authed_client.get(f"/api/v1/files/{key}")
        assert response.status_code == 403


class TestFileDelete:
    @pytest.fixture(autouse=True)
    def _setup(self, mock_storage: AsyncMock) -> Generator[None, None, None]:
        async def _db_override() -> AsyncGenerator[AsyncMock, None]:
            yield AsyncMock()

        app.dependency_overrides[get_db] = _db_override
        app.dependency_overrides[get_storage] = lambda: mock_storage
        yield
        app.dependency_overrides.clear()

    def test_delete_own_file(
        self,
        authed_client: TestClient,
        mock_storage: AsyncMock,
    ) -> None:
        key = f"{TEST_USER_ID}/abc.txt"
        response = authed_client.delete(f"/api/v1/files/{key}")
        assert response.status_code == 204
        mock_storage.delete.assert_called_once()

    def test_delete_other_user_file_403(self, authed_client: TestClient) -> None:
        key = f"{OTHER_USER_ID}/abc.txt"
        response = authed_client.delete(f"/api/v1/files/{key}")
        assert response.status_code == 403


class TestFileUnauthenticated:
    @pytest.fixture(autouse=True)
    def _setup(self) -> Generator[None, None, None]:
        async def _db_override() -> AsyncGenerator[AsyncMock, None]:
            yield AsyncMock()

        app.dependency_overrides[get_db] = _db_override
        yield
        app.dependency_overrides.clear()

    def test_upload_unauthenticated(self, client: TestClient) -> None:
        file = BytesIO(b"hello")
        response = client.post(
            "/api/v1/files/upload",
            files={"file": ("test.txt", file, "text/plain")},
        )
        assert response.status_code == 401

    def test_get_unauthenticated(self, client: TestClient) -> None:
        response = client.get(f"/api/v1/files/{TEST_USER_ID}/abc.txt")
        assert response.status_code == 401

    def test_delete_unauthenticated(self, client: TestClient) -> None:
        response = client.delete(f"/api/v1/files/{TEST_USER_ID}/abc.txt")
        assert response.status_code == 401
