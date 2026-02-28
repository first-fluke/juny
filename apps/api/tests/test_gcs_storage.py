"""Tests for the GCS storage provider."""

from __future__ import annotations

import sys
from unittest.mock import MagicMock, patch

import pytest


@pytest.fixture(autouse=True)
def _mock_gcs_module():
    """Inject fake google.cloud.storage into sys.modules."""
    fake_gcs = MagicMock()
    with patch.dict(
        sys.modules,
        {
            "google.cloud.storage": fake_gcs,
            "google.cloud": MagicMock(),
        },
    ):
        sys.modules.pop("src.lib.storage.gcs", None)
        yield fake_gcs
    sys.modules.pop("src.lib.storage.gcs", None)


@pytest.fixture
def provider(_mock_gcs_module: MagicMock):
    """Create a GCSStorageProvider with mocked client."""
    with patch("src.lib.storage.gcs.settings") as mock_settings:
        mock_settings.GOOGLE_CLOUD_PROJECT = "test-project"
        from src.lib.storage.gcs import GCSStorageProvider

        p = GCSStorageProvider()
        p._client = MagicMock()
        return p


class TestGCSUpload:
    @pytest.mark.asyncio
    async def test_upload(self, provider: object) -> None:
        from src.lib.storage.gcs import GCSStorageProvider

        p: GCSStorageProvider = provider  # type: ignore[assignment]
        mock_blob = MagicMock()
        p._client.bucket.return_value.blob.return_value = mock_blob

        result = await p.upload(
            "test-bucket", "key.txt", b"hello", content_type="text/plain"
        )

        assert result == "key.txt"
        mock_blob.upload_from_string.assert_called_once_with(
            b"hello", content_type="text/plain"
        )


class TestGCSDownload:
    @pytest.mark.asyncio
    async def test_download(self, provider: object) -> None:
        from src.lib.storage.gcs import GCSStorageProvider

        p: GCSStorageProvider = provider  # type: ignore[assignment]
        mock_blob = MagicMock()
        mock_blob.download_as_bytes.return_value = b"content"
        p._client.bucket.return_value.blob.return_value = mock_blob

        data = await p.download("test-bucket", "key.txt")

        assert data == b"content"
        mock_blob.download_as_bytes.assert_called_once()


class TestGCSDelete:
    @pytest.mark.asyncio
    async def test_delete(self, provider: object) -> None:
        from src.lib.storage.gcs import GCSStorageProvider

        p: GCSStorageProvider = provider  # type: ignore[assignment]
        mock_blob = MagicMock()
        p._client.bucket.return_value.blob.return_value = mock_blob

        await p.delete("test-bucket", "key.txt")

        mock_blob.delete.assert_called_once()


class TestGCSSignedUrl:
    @pytest.mark.asyncio
    async def test_get_signed_url(self, provider: object) -> None:
        from src.lib.storage.gcs import GCSStorageProvider

        p: GCSStorageProvider = provider  # type: ignore[assignment]
        mock_blob = MagicMock()
        mock_blob.generate_signed_url.return_value = "https://signed.url/key.txt"
        p._client.bucket.return_value.blob.return_value = mock_blob

        url = await p.get_signed_url("test-bucket", "key.txt", expires_in=600)

        assert url == "https://signed.url/key.txt"
        mock_blob.generate_signed_url.assert_called_once()
