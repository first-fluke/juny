from functools import lru_cache
from typing import Annotated

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from src.lib.auth import (
    CurrentUser,
    CurrentUserInfo,
    OptionalUser,
    get_current_user,
    get_optional_user,
)
from src.lib.database import get_db
from src.lib.storage import StorageProvider, create_storage_provider

# Type alias for database session dependency
DBSession = Annotated[AsyncSession, Depends(get_db)]


# Storage dependency
@lru_cache
def _get_storage_provider() -> StorageProvider:
    return create_storage_provider()


def get_storage() -> StorageProvider:
    """FastAPI dependency for storage provider."""
    return _get_storage_provider()


StorageDep = Annotated[StorageProvider, Depends(get_storage)]

# Re-export auth dependencies for convenience
__all__ = [
    "CurrentUser",
    "CurrentUserInfo",
    "DBSession",
    "OptionalUser",
    "StorageDep",
    "get_current_user",
    "get_optional_user",
    "get_storage",
]
