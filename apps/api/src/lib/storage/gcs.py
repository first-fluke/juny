"""Google Cloud Storage provider."""

from datetime import timedelta

from google.cloud.storage import Client

from src.lib.config import settings
from src.lib.storage.base import StorageProvider


class GCSStorageProvider(StorageProvider):
    """StorageProvider backed by Google Cloud Storage."""

    def __init__(self) -> None:
        self._client = Client(project=settings.GOOGLE_CLOUD_PROJECT)

    async def upload(
        self,
        bucket: str,
        key: str,
        data: bytes,
        content_type: str | None = None,
    ) -> str:
        blob = self._client.bucket(bucket).blob(key)
        blob.upload_from_string(
            data, content_type=content_type or "application/octet-stream"
        )
        return key

    async def download(self, bucket: str, key: str) -> bytes:
        blob = self._client.bucket(bucket).blob(key)
        result: bytes = blob.download_as_bytes()
        return result

    async def delete(self, bucket: str, key: str) -> None:
        blob = self._client.bucket(bucket).blob(key)
        blob.delete()

    async def get_signed_url(
        self, bucket: str, key: str, expires_in: int = 3600
    ) -> str:
        blob = self._client.bucket(bucket).blob(key)
        url: str = blob.generate_signed_url(
            version="v4",
            expiration=timedelta(seconds=expires_in),
            method="GET",
        )
        return url
