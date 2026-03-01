"""Pydantic schemas for navigation request/response models."""

import uuid
from datetime import datetime
from typing import Any

from pydantic import BaseModel, Field


class NavigationSessionCreate(BaseModel):
    """Request body for starting a navigation session."""

    host_id: uuid.UUID
    destination_query: str = Field(..., min_length=1, max_length=500)
    origin_lat: float
    origin_lng: float


class NavigationSessionResponse(BaseModel):
    """Response model for a navigation session."""

    id: uuid.UUID
    host_id: uuid.UUID
    status: str
    destination_name: str
    destination_lat: float
    destination_lng: float
    origin_lat: float
    origin_lng: float
    route_data: dict[str, Any]
    current_step_index: int
    created_at: datetime
    completed_at: datetime | None

    model_config = {"from_attributes": True}


class RerouteRequest(BaseModel):
    """Request body for rerouting from the current location."""

    current_lat: float
    current_lng: float


class LocationWaypointCreate(BaseModel):
    """Request body for recording a single GPS waypoint."""

    host_id: uuid.UUID
    session_id: uuid.UUID | None = None
    lat: float
    lng: float
    altitude: float | None = None
    accuracy: float | None = None
    speed: float | None = None
    heading: float | None = None


class LocationWaypointResponse(BaseModel):
    """Response model for a location waypoint."""

    id: uuid.UUID
    host_id: uuid.UUID
    session_id: uuid.UUID | None
    lat: float
    lng: float
    altitude: float | None
    accuracy: float | None
    speed: float | None
    heading: float | None
    created_at: datetime

    model_config = {"from_attributes": True}


class RouteTraceResponse(BaseModel):
    """Response model for a session's route trace (waypoint history)."""

    host_id: uuid.UUID
    session_id: uuid.UUID | None
    waypoints: list[LocationWaypointResponse]
    total_distance_meters: float
    duration_seconds: float
