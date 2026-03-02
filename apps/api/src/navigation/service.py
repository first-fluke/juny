"""Business logic for navigation sessions and location tracking."""

import math
import uuid
from datetime import UTC, datetime

from sqlalchemy.ext.asyncio import AsyncSession

from src.lib.maps.base import LatLng, MapProvider, RouteResult
from src.navigation import repository
from src.navigation.model import LocationWaypoint, NavigationSession
from src.navigation.schemas import (
    LocationWaypointCreate,
    NavigationSessionCreate,
)


async def start_navigation(
    db: AsyncSession,
    map_provider: MapProvider,
    payload: NavigationSessionCreate,
) -> NavigationSession:
    """Geocode destination, get directions, and create a new session."""
    # Cancel any existing active session (lock row to prevent TOCTOU)
    existing = await repository.find_active_session_for_update(db, payload.host_id)
    if existing:
        await repository.update_session_status(
            db,
            existing.id,
            "cancelled",
            completed_at=datetime.now(UTC),
        )

    # Geocode the destination query
    origin = LatLng(lat=payload.origin_lat, lng=payload.origin_lng)
    results = await map_provider.geocode(
        payload.destination_query, location_bias=origin
    )
    if not results:
        msg = f"Could not geocode destination: {payload.destination_query}"
        raise ValueError(msg)

    dest = results[0]

    # Get walking directions
    route = await map_provider.get_directions(origin, dest.location)

    nav_session = NavigationSession(
        host_id=payload.host_id,
        status="active",
        destination_name=dest.formatted_address,
        destination_lat=dest.location.lat,
        destination_lng=dest.location.lng,
        origin_lat=payload.origin_lat,
        origin_lng=payload.origin_lng,
        route_data=route.model_dump(),
        current_step_index=0,
    )
    return await repository.create_session(db, nav_session)


async def cancel_navigation(
    db: AsyncSession,
    session_id: uuid.UUID,
) -> None:
    """Cancel an active navigation session."""
    await repository.update_session_status(
        db, session_id, "cancelled", completed_at=datetime.now(UTC)
    )


async def complete_navigation(
    db: AsyncSession,
    session_id: uuid.UUID,
) -> None:
    """Mark a navigation session as completed."""
    await repository.update_session_status(
        db, session_id, "completed", completed_at=datetime.now(UTC)
    )


async def reroute_navigation(
    db: AsyncSession,
    map_provider: MapProvider,
    session_id: uuid.UUID,
    current_lat: float,
    current_lng: float,
) -> NavigationSession:
    """Recalculate route from current position to existing destination."""
    nav = await repository.find_session_by_id_for_update(db, session_id)
    if nav is None:
        msg = f"Navigation session not found: {session_id}"
        raise ValueError(msg)

    origin = LatLng(lat=current_lat, lng=current_lng)
    destination = LatLng(lat=nav.destination_lat, lng=nav.destination_lng)
    route = await map_provider.get_directions(origin, destination)

    await repository.update_session_route(db, session_id, route.model_dump())
    await db.refresh(nav)
    return nav


async def record_waypoint(
    db: AsyncSession,
    payload: LocationWaypointCreate,
) -> LocationWaypoint:
    """Record a single GPS waypoint."""
    wp = LocationWaypoint(
        host_id=payload.host_id,
        session_id=payload.session_id,
        lat=payload.lat,
        lng=payload.lng,
        altitude=payload.altitude,
        accuracy=payload.accuracy,
        speed=payload.speed,
        heading=payload.heading,
    )
    return await repository.create_waypoint(db, wp)


async def record_waypoints_batch(
    db: AsyncSession,
    payloads: list[LocationWaypointCreate],
) -> list[LocationWaypoint]:
    """Record multiple GPS waypoints in a batch."""
    waypoints = [
        LocationWaypoint(
            host_id=p.host_id,
            session_id=p.session_id,
            lat=p.lat,
            lng=p.lng,
            altitude=p.altitude,
            accuracy=p.accuracy,
            speed=p.speed,
            heading=p.heading,
        )
        for p in payloads
    ]
    return await repository.create_waypoints_batch(db, waypoints)


async def get_host_location(
    db: AsyncSession,
    host_id: uuid.UUID,
) -> LocationWaypoint | None:
    """Get the most recent location for a host."""
    return await repository.find_latest_waypoint(db, host_id)


async def get_route_trace(
    db: AsyncSession,
    session_id: uuid.UUID,
) -> list[LocationWaypoint]:
    """Get all waypoints for a session (route trace visualization)."""
    return await repository.find_waypoints_by_session(db, session_id)


def check_off_route(
    current_lat: float,
    current_lng: float,
    route_data: dict[str, object],
    step_index: int,
    threshold_meters: float = 50.0,
) -> bool:
    """Check if current position is off the planned route.

    Pure function: compares current location to the expected step's
    start/end locations using haversine distance.
    """
    route = RouteResult.model_validate(route_data)
    if not route.steps or step_index >= len(route.steps):
        return False

    step = route.steps[step_index]
    dist_to_start = _haversine(
        current_lat, current_lng, step.start_location.lat, step.start_location.lng
    )
    dist_to_end = _haversine(
        current_lat, current_lng, step.end_location.lat, step.end_location.lng
    )

    return min(dist_to_start, dist_to_end) > threshold_meters


def _haversine(lat1: float, lng1: float, lat2: float, lng2: float) -> float:
    """Calculate distance in meters between two coordinates using Haversine."""
    r = 6_371_000  # Earth radius in meters
    phi1 = math.radians(lat1)
    phi2 = math.radians(lat2)
    delta_phi = math.radians(lat2 - lat1)
    delta_lambda = math.radians(lng2 - lng1)

    a = (
        math.sin(delta_phi / 2) ** 2
        + math.cos(phi1) * math.cos(phi2) * math.sin(delta_lambda / 2) ** 2
    )
    return r * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
