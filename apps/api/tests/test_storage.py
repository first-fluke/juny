"""Tests for the storage module (factory + MinIO provider)."""

from __future__ import annotations

import sys
from unittest.mock import MagicMock, patch

import pytest

from src.lib.storage.factory import create_storage_provider
from src.lib.storage.minio import MinIOStorageProvider

# ---------------------------------------------------------------------------
# Factory
# ---------------------------------------------------------------------------


class TestStorageFactory:
    @patch("src.lib.storage.factory.settings")
    @patch("src.lib.storage.factory.MinIOStorageProvider")
    def test_minio_backend(self, mock_cls: MagicMock, mock_settings: MagicMock) -> None:
        mock_settings.STORAGE_BACKEND = "minio"
        result = create_storage_provider()
        mock_cls.assert_called_once()
        assert result is mock_cls.return_value

    @patch("src.lib.storage.factory.settings")
    def test_gcs_backend(self, mock_settings: MagicMock) -> None:
        mock_settings.STORAGE_BACKEND = "gcs"
        # Fake google.cloud.storage so the optional import succeeds
        fake_gcs = MagicMock()
        with patch.dict(
            sys.modules,
            {"google.cloud.storage": fake_gcs, "google.cloud": MagicMock()},
        ):
            # Remove any cached gcs module so factory re-imports it
            sys.modules.pop("src.lib.storage.gcs", None)
            result = create_storage_provider()
            from src.lib.storage.gcs import GCSStorageProvider

            assert isinstance(result, GCSStorageProvider)

    @patch("src.lib.storage.factory.settings")
    def test_unsupported_backend(self, mock_settings: MagicMock) -> None:
        mock_settings.STORAGE_BACKEND = "unsupported"
        with pytest.raises(ValueError, match="Unsupported storage backend"):
            create_storage_provider()


# ---------------------------------------------------------------------------
# MinIO Provider
# ---------------------------------------------------------------------------


class TestMinIOStorage:
    @pytest.fixture
    def provider(self) -> MinIOStorageProvider:
        with patch("src.lib.storage.minio.Minio") as mock_cls:
            p = MinIOStorageProvider()
            p._client = mock_cls.return_value
            return p

    @pytest.mark.asyncio
    async def test_upload(self, provider: MinIOStorageProvider) -> None:
        provider._client.bucket_exists.return_value = True
        result = await provider.upload(
            "bucket", "key.txt", b"hello", content_type="text/plain"
        )
        assert result == "key.txt"
        provider._client.put_object.assert_called_once()

    @pytest.mark.asyncio
    async def test_upload_creates_bucket(self, provider: MinIOStorageProvider) -> None:
        provider._client.bucket_exists.return_value = False
        await provider.upload("bucket", "key.txt", b"hello")
        provider._client.make_bucket.assert_called_once_with("bucket")

    @pytest.mark.asyncio
    async def test_download(self, provider: MinIOStorageProvider) -> None:
        mock_resp = MagicMock()
        mock_resp.read.return_value = b"content"
        provider._client.get_object.return_value = mock_resp
        data = await provider.download("bucket", "key.txt")
        assert data == b"content"
        mock_resp.close.assert_called_once()
        mock_resp.release_conn.assert_called_once()

    @pytest.mark.asyncio
    async def test_delete(self, provider: MinIOStorageProvider) -> None:
        await provider.delete("bucket", "key.txt")
        provider._client.remove_object.assert_called_once_with("bucket", "key.txt")

    @pytest.mark.asyncio
    async def test_get_signed_url(self, provider: MinIOStorageProvider) -> None:
        provider._client.presigned_get_object.return_value = "https://signed.url"
        url = await provider.get_signed_url("bucket", "key.txt", expires_in=600)
        assert url == "https://signed.url"
        provider._client.presigned_get_object.assert_called_once()
