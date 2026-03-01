"""Google Maps Directions & Geocoding API provider."""

from typing import Any

import httpx
import structlog

from src.lib.config import settings
from src.lib.maps.base import (
    GeocodingResult,
    LatLng,
    MapProvider,
    RouteResult,
    RouteStep,
)
from src.lib.resilience import with_retry

logger = structlog.get_logger(__name__)

_DIRECTIONS_URL = "https://maps.googleapis.com/maps/api/directions/json"
_GEOCODE_URL = "https://maps.googleapis.com/maps/api/geocode/json"


class GoogleMapProvider(MapProvider):
    """Google Maps API implementation via httpx."""

    def __init__(self, api_key: str | None = None) -> None:
        self._api_key = api_key or settings.GOOGLE_MAPS_API_KEY or ""

    @with_retry()
    async def get_directions(
        self,
        origin: LatLng,
        destination: LatLng,
        *,
        mode: str = "walking",
        language: str = "ko",
    ) -> RouteResult:
        """Call Google Maps Directions API and return parsed RouteResult."""
        params: dict[str, str] = {
            "origin": f"{origin.lat},{origin.lng}",
            "destination": f"{destination.lat},{destination.lng}",
            "mode": mode,
            "language": language,
            "key": self._api_key,
        }
        async with httpx.AsyncClient() as client:
            resp = await client.get(_DIRECTIONS_URL, params=params, timeout=10.0)
            resp.raise_for_status()
            data = resp.json()

        routes = data.get("routes", [])
        if not routes:
            logger.warning("google_directions_no_routes", status=data.get("status"))
            return RouteResult(
                steps=[],
                total_distance_meters=0,
                total_duration_seconds=0,
                overview_polyline="",
            )

        route = routes[0]
        leg = route["legs"][0]

        steps = [_parse_step(s) for s in leg.get("steps", [])]
        return RouteResult(
            steps=steps,
            total_distance_meters=leg["distance"]["value"],
            total_duration_seconds=leg["duration"]["value"],
            overview_polyline=route.get("overview_polyline", {}).get("points", ""),
        )

    @with_retry()
    async def geocode(
        self,
        query: str,
        *,
        language: str = "ko",
        location_bias: LatLng | None = None,
    ) -> list[GeocodingResult]:
        """Call Google Maps Geocoding API."""
        params: dict[str, str] = {
            "address": query,
            "language": language,
            "key": self._api_key,
        }
        if location_bias:
            params["bounds"] = (
                f"{location_bias.lat - 0.05},{location_bias.lng - 0.05}"
                f"|{location_bias.lat + 0.05},{location_bias.lng + 0.05}"
            )
        async with httpx.AsyncClient() as client:
            resp = await client.get(_GEOCODE_URL, params=params, timeout=10.0)
            resp.raise_for_status()
            data = resp.json()

        return [_parse_geocode(r) for r in data.get("results", [])]

    @with_retry()
    async def reverse_geocode(
        self,
        location: LatLng,
        *,
        language: str = "ko",
    ) -> GeocodingResult | None:
        """Call Google Maps Reverse Geocoding API."""
        params: dict[str, str] = {
            "latlng": f"{location.lat},{location.lng}",
            "language": language,
            "key": self._api_key,
        }
        async with httpx.AsyncClient() as client:
            resp = await client.get(_GEOCODE_URL, params=params, timeout=10.0)
            resp.raise_for_status()
            data = resp.json()

        results = data.get("results", [])
        if not results:
            return None
        return _parse_geocode(results[0])


def _parse_step(raw: dict[str, Any]) -> RouteStep:
    """Parse a single Google Directions step dict."""
    return RouteStep(
        instruction=raw.get("html_instructions", ""),
        distance_meters=raw.get("distance", {}).get("value", 0),
        duration_seconds=raw.get("duration", {}).get("value", 0),
        start_location=LatLng(
            lat=raw["start_location"]["lat"],
            lng=raw["start_location"]["lng"],
        ),
        end_location=LatLng(
            lat=raw["end_location"]["lat"],
            lng=raw["end_location"]["lng"],
        ),
        maneuver=raw.get("maneuver"),
        polyline=raw.get("polyline", {}).get("points", ""),
    )


def _parse_geocode(raw: dict[str, Any]) -> GeocodingResult:
    """Parse a single Google Geocoding result dict."""
    loc = raw["geometry"]["location"]
    return GeocodingResult(
        formatted_address=raw.get("formatted_address", ""),
        location=LatLng(lat=loc["lat"], lng=loc["lng"]),
    )
