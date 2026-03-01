"""Factory for creating MapProvider instances based on settings."""

from src.lib.config import settings
from src.lib.maps.base import MapProvider
from src.lib.maps.google import GoogleMapProvider


def create_map_provider() -> MapProvider:
    """Create a MapProvider based on MAP_PROVIDER setting."""
    if settings.MAP_PROVIDER == "google":
        return GoogleMapProvider()
    msg = f"Unknown map provider: {settings.MAP_PROVIDER}"
    raise ValueError(msg)
