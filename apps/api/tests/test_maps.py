"""Tests for lib/maps: MapProvider ABC, GoogleMapProvider, factory."""

from unittest.mock import AsyncMock, MagicMock, patch

import httpx
import pytest

from src.lib.maps.base import (
    GeocodingResult,
    LatLng,
    MapProvider,
    RouteResult,
    RouteStep,
)
from src.lib.maps.factory import create_map_provider
from src.lib.maps.google import GoogleMapProvider

_HTTPX_GET = "httpx.AsyncClient.get"


class TestMapProviderABC:
    """MapProvider ABC cannot be instantiated directly."""

    def test_cannot_instantiate_abc(self) -> None:
        with pytest.raises(TypeError):
            MapProvider()  # type: ignore[abstract]


class TestLatLngModel:
    def test_roundtrip(self) -> None:
        ll = LatLng(lat=37.5665, lng=126.978)
        assert ll.lat == 37.5665
        assert ll.lng == 126.978


class TestRouteModels:
    def test_route_step(self) -> None:
        step = RouteStep(
            instruction="직진하세요",
            distance_meters=100.0,
            duration_seconds=60.0,
            start_location=LatLng(lat=37.0, lng=127.0),
            end_location=LatLng(lat=37.001, lng=127.001),
            maneuver="straight",
            polyline="abc123",
        )
        assert step.instruction == "직진하세요"
        assert step.maneuver == "straight"

    def test_route_result(self) -> None:
        result = RouteResult(
            steps=[],
            total_distance_meters=1200.0,
            total_duration_seconds=900.0,
            overview_polyline="polyline_data",
        )
        assert result.total_distance_meters == 1200.0
        assert result.overview_polyline == "polyline_data"

    def test_geocoding_result(self) -> None:
        result = GeocodingResult(
            formatted_address="서울특별시 용산구 서울역",
            location=LatLng(lat=37.5547, lng=126.9706),
        )
        assert "서울역" in result.formatted_address


class TestGoogleMapProvider:
    """GoogleMapProvider tests with mocked httpx."""

    @pytest.mark.asyncio
    @patch(_HTTPX_GET)
    async def test_get_directions_success(self, mock_get: AsyncMock) -> None:
        mock_response = MagicMock(spec=httpx.Response)
        mock_response.json.return_value = {
            "status": "OK",
            "routes": [
                {
                    "legs": [
                        {
                            "distance": {"value": 1200},
                            "duration": {"value": 900},
                            "steps": [
                                {
                                    "html_instructions": "직진하세요",
                                    "distance": {"value": 100},
                                    "duration": {"value": 60},
                                    "start_location": {"lat": 37.0, "lng": 127.0},
                                    "end_location": {"lat": 37.001, "lng": 127.001},
                                    "maneuver": "straight",
                                    "polyline": {"points": "abc"},
                                },
                            ],
                        }
                    ],
                    "overview_polyline": {"points": "overview123"},
                }
            ],
        }
        mock_response.raise_for_status = MagicMock()
        mock_get.return_value = mock_response

        provider = GoogleMapProvider(api_key="test-key")
        result = await provider.get_directions(
            LatLng(lat=37.0, lng=127.0),
            LatLng(lat=37.01, lng=127.01),
        )

        assert result.total_distance_meters == 1200
        assert result.total_duration_seconds == 900
        assert len(result.steps) == 1
        assert result.steps[0].instruction == "직진하세요"
        assert result.overview_polyline == "overview123"

    @pytest.mark.asyncio
    @patch(_HTTPX_GET)
    async def test_get_directions_no_routes(self, mock_get: AsyncMock) -> None:
        mock_response = MagicMock(spec=httpx.Response)
        mock_response.json.return_value = {"status": "ZERO_RESULTS", "routes": []}
        mock_response.raise_for_status = MagicMock()
        mock_get.return_value = mock_response

        provider = GoogleMapProvider(api_key="test-key")
        result = await provider.get_directions(
            LatLng(lat=37.0, lng=127.0),
            LatLng(lat=37.01, lng=127.01),
        )

        assert result.steps == []
        assert result.total_distance_meters == 0

    @pytest.mark.asyncio
    @patch(_HTTPX_GET)
    async def test_geocode_success(self, mock_get: AsyncMock) -> None:
        mock_response = MagicMock(spec=httpx.Response)
        mock_response.json.return_value = {
            "results": [
                {
                    "formatted_address": "서울특별시 용산구 서울역",
                    "geometry": {"location": {"lat": 37.5547, "lng": 126.9706}},
                }
            ],
        }
        mock_response.raise_for_status = MagicMock()
        mock_get.return_value = mock_response

        provider = GoogleMapProvider(api_key="test-key")
        results = await provider.geocode("서울역")

        assert len(results) == 1
        assert results[0].formatted_address == "서울특별시 용산구 서울역"
        assert results[0].location.lat == pytest.approx(37.5547)

    @pytest.mark.asyncio
    @patch(_HTTPX_GET)
    async def test_geocode_with_location_bias(self, mock_get: AsyncMock) -> None:
        mock_response = MagicMock(spec=httpx.Response)
        mock_response.json.return_value = {"results": []}
        mock_response.raise_for_status = MagicMock()
        mock_get.return_value = mock_response

        provider = GoogleMapProvider(api_key="test-key")
        results = await provider.geocode(
            "서울역",
            location_bias=LatLng(lat=37.5, lng=127.0),
        )

        assert results == []
        # Verify bounds param was included
        call_kwargs = mock_get.call_args
        assert "bounds" in call_kwargs.kwargs.get("params", {})

    @pytest.mark.asyncio
    @patch(_HTTPX_GET)
    async def test_reverse_geocode_success(self, mock_get: AsyncMock) -> None:
        mock_response = MagicMock(spec=httpx.Response)
        mock_response.json.return_value = {
            "results": [
                {
                    "formatted_address": "서울역",
                    "geometry": {"location": {"lat": 37.5547, "lng": 126.9706}},
                }
            ],
        }
        mock_response.raise_for_status = MagicMock()
        mock_get.return_value = mock_response

        provider = GoogleMapProvider(api_key="test-key")
        result = await provider.reverse_geocode(LatLng(lat=37.5547, lng=126.9706))

        assert result is not None
        assert "서울역" in result.formatted_address

    @pytest.mark.asyncio
    @patch(_HTTPX_GET)
    async def test_reverse_geocode_no_results(self, mock_get: AsyncMock) -> None:
        mock_response = MagicMock(spec=httpx.Response)
        mock_response.json.return_value = {"results": []}
        mock_response.raise_for_status = MagicMock()
        mock_get.return_value = mock_response

        provider = GoogleMapProvider(api_key="test-key")
        result = await provider.reverse_geocode(LatLng(lat=0.0, lng=0.0))

        assert result is None


class TestMapFactory:
    @patch("src.lib.maps.factory.settings")
    def test_create_google_provider(self, mock_settings: MagicMock) -> None:
        mock_settings.MAP_PROVIDER = "google"
        provider = create_map_provider()
        assert isinstance(provider, GoogleMapProvider)

    @patch("src.lib.maps.factory.settings")
    def test_unknown_provider_raises(self, mock_settings: MagicMock) -> None:
        mock_settings.MAP_PROVIDER = "unknown"
        with pytest.raises(ValueError, match="Unknown map provider"):
            create_map_provider()
