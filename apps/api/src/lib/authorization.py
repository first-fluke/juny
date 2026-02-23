"""Authorization helpers for resource access control.

Provides functions to verify that the current user has permission
to access host-scoped resources, either as the host themselves
or as a caregiver with an active CareRelation.
"""

import uuid

from fastapi import HTTPException, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from src.lib.auth import CurrentUserInfo
from src.relations.model import CareRelation


async def authorize_host_access(
    db: AsyncSession,
    *,
    user: CurrentUserInfo,
    host_id: uuid.UUID,
) -> None:
    """Verify that *user* may access resources belonging to *host_id*.

    Access is granted when:
      1. The user IS the host (``user.id == host_id``), OR
      2. The user has an **active** CareRelation as caregiver for this host.

    Raises:
        HTTPException 403 if access is denied.
    """
    user_uuid = uuid.UUID(user.id)

    if user_uuid == host_id:
        return

    result = await db.execute(
        select(CareRelation.id)
        .where(
            CareRelation.host_id == host_id,
            CareRelation.caregiver_id == user_uuid,
            CareRelation.is_active.is_(True),
        )
        .limit(1)
    )
    if result.scalar_one_or_none() is not None:
        return

    raise HTTPException(
        status_code=status.HTTP_403_FORBIDDEN,
        detail="You do not have access to this host's resources",
    )


async def authorize_relation_access(
    db: AsyncSession,
    *,
    user: CurrentUserInfo,
    relation: CareRelation,
) -> None:
    """Verify that *user* is either the host or caregiver in the relation.

    Raises:
        HTTPException 403 if access is denied.
    """
    user_uuid = uuid.UUID(user.id)

    if user_uuid in (relation.host_id, relation.caregiver_id):
        return

    raise HTTPException(
        status_code=status.HTTP_403_FORBIDDEN,
        detail="You do not have access to this care relation",
    )
