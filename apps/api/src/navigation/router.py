"""Navigation REST endpoints for sessions, waypoints, and location."""

import uuid

from fastapi import APIRouter, Query, status

from src.common.errors import RES_006, RES_007, SVC_006, raise_api_error
from src.lib.authorization import authorize_host_access
from src.lib.config import settings
from src.lib.dependencies import CurrentUser, DBSession, MapsDep
from src.navigation import repository, service
from src.navigation.schemas import (
    LocationWaypointCreate,
    LocationWaypointResponse,
    NavigationSessionCreate,
    NavigationSessionResponse,
    RerouteRequest,
    RouteTraceResponse,
)
from src.navigation.service import _haversine

router = APIRouter()


def _require_maps() -> None:
    """Guard: raise 503 if maps provider is not configured."""
    if not settings.maps_configured:
        raise_api_error(SVC_006, status.HTTP_503_SERVICE_UNAVAILABLE)


@router.post(
    "/sessions",
    response_model=NavigationSessionResponse,
    status_code=status.HTTP_201_CREATED,
)
async def start_navigation(
    payload: NavigationSessionCreate,
    db: DBSession,
    user: CurrentUser,
    maps: MapsDep,
) -> NavigationSessionResponse:
    """Start a new navigation session for a host."""
    _require_maps()
    await authorize_host_access(db, user=user, host_id=payload.host_id)
    nav = await service.start_navigation(db, maps, payload)
    return NavigationSessionResponse.model_validate(nav)


@router.get(
    "/sessions/active",
    response_model=NavigationSessionResponse,
)
async def get_active_session(
    db: DBSession,
    user: CurrentUser,
    host_id: uuid.UUID = Query(...),
) -> NavigationSessionResponse:
    """Get the currently active navigation session for a host."""
    await authorize_host_access(db, user=user, host_id=host_id)
    nav = await repository.find_active_session(db, host_id)
    if nav is None:
        raise_api_error(RES_007, status.HTTP_404_NOT_FOUND)
    return NavigationSessionResponse.model_validate(nav)


@router.get(
    "/sessions/{session_id}",
    response_model=NavigationSessionResponse,
)
async def get_session(
    session_id: uuid.UUID,
    db: DBSession,
    user: CurrentUser,
) -> NavigationSessionResponse:
    """Get a navigation session by ID."""
    nav = await repository.find_session_by_id(db, session_id)
    if nav is None:
        raise_api_error(RES_006, status.HTTP_404_NOT_FOUND)
    await authorize_host_access(db, user=user, host_id=nav.host_id)
    return NavigationSessionResponse.model_validate(nav)


@router.post(
    "/sessions/{session_id}/cancel",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def cancel_navigation(
    session_id: uuid.UUID,
    db: DBSession,
    user: CurrentUser,
) -> None:
    """Cancel an active navigation session."""
    nav = await repository.find_session_by_id(db, session_id)
    if nav is None:
        raise_api_error(RES_006, status.HTTP_404_NOT_FOUND)
    await authorize_host_access(db, user=user, host_id=nav.host_id)
    await service.cancel_navigation(db, session_id)


@router.post(
    "/sessions/{session_id}/reroute",
    response_model=NavigationSessionResponse,
)
async def reroute_navigation(
    session_id: uuid.UUID,
    payload: RerouteRequest,
    db: DBSession,
    user: CurrentUser,
    maps: MapsDep,
) -> NavigationSessionResponse:
    """Reroute a navigation session from the current location."""
    _require_maps()
    nav = await repository.find_session_by_id(db, session_id)
    if nav is None:
        raise_api_error(RES_006, status.HTTP_404_NOT_FOUND)
    await authorize_host_access(db, user=user, host_id=nav.host_id)
    updated = await service.reroute_navigation(
        db, maps, session_id, payload.current_lat, payload.current_lng
    )
    return NavigationSessionResponse.model_validate(updated)


@router.post(
    "/waypoints",
    response_model=LocationWaypointResponse,
    status_code=status.HTTP_201_CREATED,
)
async def create_waypoint(
    payload: LocationWaypointCreate,
    db: DBSession,
    user: CurrentUser,
) -> LocationWaypointResponse:
    """Record a single GPS waypoint."""
    await authorize_host_access(db, user=user, host_id=payload.host_id)
    wp = await service.record_waypoint(db, payload)
    return LocationWaypointResponse.model_validate(wp)


@router.post(
    "/waypoints/batch",
    response_model=list[LocationWaypointResponse],
    status_code=status.HTTP_201_CREATED,
)
async def create_waypoints_batch(
    payloads: list[LocationWaypointCreate],
    db: DBSession,
    user: CurrentUser,
) -> list[LocationWaypointResponse]:
    """Record multiple GPS waypoints in a batch."""
    if payloads:
        await authorize_host_access(db, user=user, host_id=payloads[0].host_id)
    wps = await service.record_waypoints_batch(db, payloads)
    return [LocationWaypointResponse.model_validate(wp) for wp in wps]


@router.get(
    "/location/{host_id}",
    response_model=LocationWaypointResponse | None,
)
async def get_host_location(
    host_id: uuid.UUID,
    db: DBSession,
    user: CurrentUser,
) -> LocationWaypointResponse | None:
    """Get the most recent location for a host (Concierge polling)."""
    await authorize_host_access(db, user=user, host_id=host_id)
    wp = await service.get_host_location(db, host_id)
    if wp is None:
        return None
    return LocationWaypointResponse.model_validate(wp)


@router.get(
    "/trace/{session_id}",
    response_model=RouteTraceResponse,
)
async def get_route_trace(
    session_id: uuid.UUID,
    db: DBSession,
    user: CurrentUser,
) -> RouteTraceResponse:
    """Get waypoint trace for a navigation session (visualization)."""
    nav = await repository.find_session_by_id(db, session_id)
    if nav is None:
        raise_api_error(RES_006, status.HTTP_404_NOT_FOUND)
    await authorize_host_access(db, user=user, host_id=nav.host_id)

    waypoints = await service.get_route_trace(db, session_id)
    wp_responses = [LocationWaypointResponse.model_validate(wp) for wp in waypoints]

    # Calculate total distance from waypoints
    total_dist = 0.0
    for i in range(1, len(waypoints)):
        total_dist += _haversine(
            waypoints[i - 1].lat,
            waypoints[i - 1].lng,
            waypoints[i].lat,
            waypoints[i].lng,
        )

    duration = 0.0
    if len(waypoints) >= 2:
        duration = (waypoints[-1].created_at - waypoints[0].created_at).total_seconds()

    return RouteTraceResponse(
        host_id=nav.host_id,
        session_id=session_id,
        waypoints=wp_responses,
        total_distance_meters=round(total_dist, 1),
        duration_seconds=round(duration, 1),
    )
