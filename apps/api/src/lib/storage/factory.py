"""Factory for creating StorageProvider instances."""

from src.lib.config import settings
from src.lib.storage.base import StorageProvider
from src.lib.storage.minio import MinIOStorageProvider


def create_storage_provider() -> StorageProvider:
    """Create a storage provider based on the STORAGE_BACKEND setting."""
    if settings.STORAGE_BACKEND == "minio":
        return MinIOStorageProvider()
    elif settings.STORAGE_BACKEND == "gcs":
        from src.lib.storage.gcs import GCSStorageProvider  # optional dep

        return GCSStorageProvider()
    else:
        raise ValueError(f"Unsupported storage backend: {settings.STORAGE_BACKEND}")
