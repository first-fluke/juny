"""Data access layer for authentication.

Delegates to users/repository to avoid duplication.
"""

from sqlalchemy.ext.asyncio import AsyncSession

from src.users import repository as users_repo
from src.users.model import User

# Re-use read helpers directly (same signature).
find_by_email = users_repo.find_by_email
find_by_id = users_repo.find_by_id


async def create_user(db: AsyncSession, user: User) -> User:
    """Persist a new user."""
    return await users_repo.save(db, user)
