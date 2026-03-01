"""MapProvider ABC and shared models for geocoding / directions."""

from abc import ABC, abstractmethod

from pydantic import BaseModel


class LatLng(BaseModel):
    """Geographic coordinate pair."""

    lat: float
    lng: float


class RouteStep(BaseModel):
    """A single step within a navigation route."""

    instruction: str
    distance_meters: float
    duration_seconds: float
    start_location: LatLng
    end_location: LatLng
    maneuver: str | None = None
    polyline: str


class RouteResult(BaseModel):
    """Complete directions result with steps and overview."""

    steps: list[RouteStep]
    total_distance_meters: float
    total_duration_seconds: float
    overview_polyline: str


class GeocodingResult(BaseModel):
    """A single geocoding match."""

    formatted_address: str
    location: LatLng


class MapProvider(ABC):
    """Abstract base class for map / directions providers."""

    @abstractmethod
    async def get_directions(
        self,
        origin: LatLng,
        destination: LatLng,
        *,
        mode: str = "walking",
        language: str = "ko",
    ) -> RouteResult:
        """Get step-by-step directions between two points."""
        ...

    @abstractmethod
    async def geocode(
        self,
        query: str,
        *,
        language: str = "ko",
        location_bias: LatLng | None = None,
    ) -> list[GeocodingResult]:
        """Forward geocode a query string to coordinates."""
        ...

    @abstractmethod
    async def reverse_geocode(
        self,
        location: LatLng,
        *,
        language: str = "ko",
    ) -> GeocodingResult | None:
        """Reverse geocode coordinates to an address."""
        ...
