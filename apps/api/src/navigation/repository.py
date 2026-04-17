"""Data access layer for navigation sessions and location waypoints."""

import uuid
from datetime import datetime

from sqlalchemy import delete, func, select, update
from sqlalchemy.ext.asyncio import AsyncSession

from src.navigation.model import LocationWaypoint, NavigationSession


async def create_session(
    db: AsyncSession,
    session: NavigationSession,
) -> NavigationSession:
    """Persist a new navigation session."""
    db.add(session)
    await db.flush()
    await db.refresh(session)
    return session


async def find_active_session(
    db: AsyncSession,
    host_id: uuid.UUID,
) -> NavigationSession | None:
    """Find the currently active navigation session for a host."""
    result = await db.execute(
        select(NavigationSession)
        .where(
            NavigationSession.host_id == host_id,
            NavigationSession.status == "active",
        )
        .order_by(NavigationSession.created_at.desc())
        .limit(1),
    )
    return result.scalar_one_or_none()


async def find_active_session_for_update(
    db: AsyncSession,
    host_id: uuid.UUID,
) -> NavigationSession | None:
    """Find active session with SELECT ... FOR UPDATE row lock."""
    result = await db.execute(
        select(NavigationSession)
        .where(
            NavigationSession.host_id == host_id,
            NavigationSession.status == "active",
        )
        .order_by(NavigationSession.created_at.desc())
        .limit(1)
        .with_for_update(),
    )
    return result.scalar_one_or_none()


async def find_session_by_id(
    db: AsyncSession,
    session_id: uuid.UUID,
) -> NavigationSession | None:
    """Find a navigation session by primary key."""
    result = await db.execute(
        select(NavigationSession).where(NavigationSession.id == session_id),
    )
    return result.scalar_one_or_none()


async def find_session_by_id_for_update(
    db: AsyncSession,
    session_id: uuid.UUID,
) -> NavigationSession | None:
    """Find a navigation session by primary key with SELECT ... FOR UPDATE."""
    result = await db.execute(
        select(NavigationSession)
        .where(NavigationSession.id == session_id)
        .with_for_update(),
    )
    return result.scalar_one_or_none()


async def update_session_status(
    db: AsyncSession,
    session_id: uuid.UUID,
    status: str,
    *,
    completed_at: datetime | None = None,
) -> None:
    """Update the status of a navigation session."""
    values: dict[str, object] = {"status": status}
    if completed_at is not None:
        values["completed_at"] = completed_at
    await db.execute(
        update(NavigationSession)
        .where(NavigationSession.id == session_id)
        .values(**values)
    )
    await db.flush()


async def update_current_step(
    db: AsyncSession,
    session_id: uuid.UUID,
    step_index: int,
) -> None:
    """Update the current step index of a navigation session."""
    await db.execute(
        update(NavigationSession)
        .where(NavigationSession.id == session_id)
        .values(current_step_index=step_index)
    )
    await db.flush()


async def update_session_route(
    db: AsyncSession,
    session_id: uuid.UUID,
    route_data: dict[str, object],
) -> None:
    """Replace the route data of a navigation session (reroute)."""
    await db.execute(
        update(NavigationSession)
        .where(NavigationSession.id == session_id)
        .values(route_data=route_data, current_step_index=0)
    )
    await db.flush()


async def create_waypoint(
    db: AsyncSession,
    waypoint: LocationWaypoint,
) -> LocationWaypoint:
    """Persist a single location waypoint."""
    db.add(waypoint)
    await db.flush()
    await db.refresh(waypoint)
    return waypoint


async def create_waypoints_batch(
    db: AsyncSession,
    waypoints: list[LocationWaypoint],
) -> list[LocationWaypoint]:
    """Persist multiple waypoints in a batch."""
    db.add_all(waypoints)
    await db.flush()
    for wp in waypoints:
        await db.refresh(wp)
    return waypoints


async def find_waypoints_by_session(
    db: AsyncSession,
    session_id: uuid.UUID,
) -> list[LocationWaypoint]:
    """Find all waypoints for a navigation session, ordered by time."""
    result = await db.execute(
        select(LocationWaypoint)
        .where(LocationWaypoint.session_id == session_id)
        .order_by(LocationWaypoint.created_at.asc()),
    )
    return list(result.scalars().all())


async def find_latest_waypoint(
    db: AsyncSession,
    host_id: uuid.UUID,
) -> LocationWaypoint | None:
    """Find the most recent waypoint for a host."""
    result = await db.execute(
        select(LocationWaypoint)
        .where(LocationWaypoint.host_id == host_id)
        .order_by(LocationWaypoint.created_at.desc())
        .limit(1),
    )
    return result.scalar_one_or_none()


async def delete_waypoints_before(
    db: AsyncSession,
    cutoff: datetime,
) -> int:
    """Delete waypoints created before *cutoff*. Returns deleted count."""
    result = await db.execute(
        delete(LocationWaypoint).where(LocationWaypoint.created_at < cutoff)
    )
    return result.rowcount  # type: ignore[no-any-return,attr-defined]


async def count_waypoints_by_session(
    db: AsyncSession,
    session_id: uuid.UUID,
) -> int:
    """Count waypoints for a navigation session."""
    result = await db.execute(
        select(func.count())
        .select_from(LocationWaypoint)
        .where(LocationWaypoint.session_id == session_id),
    )
    return result.scalar_one()


async def find_sessions_by_host(
    db: AsyncSession,
    host_id: uuid.UUID,
    *,
    limit: int = 100,
    offset: int = 0,
) -> tuple[list[NavigationSession], int]:
    """Find all navigation sessions for a host with pagination.

    Returns (sessions, total_count).
    """
    count_result = await db.execute(
        select(func.count())
        .select_from(NavigationSession)
        .where(NavigationSession.host_id == host_id),
    )
    total: int = count_result.scalar_one()

    rows_result = await db.execute(
        select(NavigationSession)
        .where(NavigationSession.host_id == host_id)
        .order_by(NavigationSession.created_at.desc())
        .limit(limit)
        .offset(offset),
    )
    return list(rows_result.scalars().all()), total


async def find_waypoints_by_host(
    db: AsyncSession,
    host_id: uuid.UUID,
    *,
    limit: int = 1000,
    offset: int = 0,
) -> tuple[list[LocationWaypoint], int]:
    """Find all waypoints for a host with pagination.

    Returns (waypoints, total_count).
    """
    count_result = await db.execute(
        select(func.count())
        .select_from(LocationWaypoint)
        .where(LocationWaypoint.host_id == host_id),
    )
    total: int = count_result.scalar_one()

    rows_result = await db.execute(
        select(LocationWaypoint)
        .where(LocationWaypoint.host_id == host_id)
        .order_by(LocationWaypoint.created_at.asc())
        .limit(limit)
        .offset(offset),
    )
    return list(rows_result.scalars().all()), total
