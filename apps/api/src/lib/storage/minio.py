"""MinIO storage provider for local development."""

import asyncio
import io
from datetime import timedelta

from minio import Minio

from src.lib.config import settings
from src.lib.storage.base import StorageProvider


class MinIOStorageProvider(StorageProvider):
    """StorageProvider backed by MinIO (S3-compatible)."""

    def __init__(self) -> None:
        self._client = Minio(
            endpoint=settings.MINIO_ENDPOINT,
            access_key=settings.MINIO_ACCESS_KEY,
            secret_key=settings.MINIO_SECRET_KEY,
            secure=False,
        )

    def _ensure_bucket(self, bucket: str) -> None:
        if not self._client.bucket_exists(bucket):
            self._client.make_bucket(bucket)

    async def upload(
        self,
        bucket: str,
        key: str,
        data: bytes,
        content_type: str | None = None,
    ) -> str:
        def _upload() -> None:
            self._ensure_bucket(bucket)
            self._client.put_object(
                bucket,
                key,
                io.BytesIO(data),
                length=len(data),
                content_type=content_type or "application/octet-stream",
            )

        await asyncio.to_thread(_upload)
        return key

    async def download(self, bucket: str, key: str) -> bytes:
        def _download() -> bytes:
            response = self._client.get_object(bucket, key)
            try:
                return response.read()
            finally:
                response.close()
                response.release_conn()

        return await asyncio.to_thread(_download)

    async def delete(self, bucket: str, key: str) -> None:
        await asyncio.to_thread(self._client.remove_object, bucket, key)

    async def get_signed_url(
        self, bucket: str, key: str, expires_in: int = 3600
    ) -> str:
        return await asyncio.to_thread(
            self._client.presigned_get_object,
            bucket,
            key,
            expires=timedelta(seconds=expires_in),
        )
