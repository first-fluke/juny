"""Tests for navigation domain: service, AI tools, and router."""

import uuid
from typing import Any
from unittest.mock import AsyncMock, MagicMock, patch

import pytest

from src.lib.ai.tools.base import _clear_registry
from src.lib.ai.tools.cancel_navigation import CancelNavigationTool
from src.lib.ai.tools.get_navigation_step import GetNavigationStepTool
from src.lib.ai.tools.start_navigation import StartNavigationTool
from src.lib.maps.base import GeocodingResult, LatLng, RouteResult, RouteStep
from src.navigation.service import _haversine, check_off_route

TEST_HOST_ID = uuid.UUID("00000000-0000-4000-8000-000000000001")
TEST_SESSION_ID = uuid.UUID("00000000-0000-4000-8000-000000000501")

_FIND_ACTIVE = "src.navigation.repository.find_active_session"
_FIND_ACTIVE_FOR_UPDATE = "src.navigation.repository.find_active_session_for_update"
_FIND_BY_ID = "src.navigation.repository.find_session_by_id"
_CREATE_SESSION = "src.navigation.repository.create_session"
_UPDATE_STATUS = "src.navigation.repository.update_session_status"
_UPDATE_ROUTE = "src.navigation.repository.update_session_route"
_FIND_LATEST_WP = "src.navigation.repository.find_latest_waypoint"
_CREATE_WP = "src.navigation.repository.create_waypoint"


def _sample_route_data() -> dict[str, Any]:
    """Create sample route data for tests."""
    return RouteResult(
        steps=[
            RouteStep(
                instruction="직진하세요",
                distance_meters=100.0,
                duration_seconds=60.0,
                start_location=LatLng(lat=37.5665, lng=126.978),
                end_location=LatLng(lat=37.5675, lng=126.978),
                maneuver="straight",
                polyline="abc",
            ),
            RouteStep(
                instruction="좌회전하세요",
                distance_meters=50.0,
                duration_seconds=30.0,
                start_location=LatLng(lat=37.5675, lng=126.978),
                end_location=LatLng(lat=37.5675, lng=126.977),
                maneuver="turn-left",
                polyline="def",
            ),
        ],
        total_distance_meters=150.0,
        total_duration_seconds=90.0,
        overview_polyline="overview",
    ).model_dump()


def _mock_nav_session(
    *,
    status: str = "active",
    step_index: int = 0,
) -> MagicMock:
    """Create a mock NavigationSession."""
    mock = MagicMock()
    mock.id = TEST_SESSION_ID
    mock.host_id = TEST_HOST_ID
    mock.status = status
    mock.destination_name = "서울역"
    mock.destination_lat = 37.5547
    mock.destination_lng = 126.9706
    mock.origin_lat = 37.5665
    mock.origin_lng = 126.978
    mock.route_data = _sample_route_data()
    mock.current_step_index = step_index
    mock.created_at = "2026-03-01T10:00:00+00:00"
    mock.completed_at = None
    return mock


def _mock_waypoint(
    lat: float = 37.5665,
    lng: float = 126.978,
) -> MagicMock:
    """Create a mock LocationWaypoint."""
    mock = MagicMock()
    mock.id = uuid.UUID("00000000-0000-4000-8000-000000000601")
    mock.host_id = TEST_HOST_ID
    mock.session_id = TEST_SESSION_ID
    mock.lat = lat
    mock.lng = lng
    mock.altitude = None
    mock.accuracy = 5.0
    mock.speed = 1.2
    mock.heading = 180.0
    mock.created_at = "2026-03-01T10:00:10+00:00"
    return mock


def _make_nav_context(
    *,
    map_provider: Any = None,
) -> dict[str, Any]:
    """Create a mock context for navigation AI tools."""
    return {
        "db": AsyncMock(),
        "host_id": TEST_HOST_ID,
        "map_provider": map_provider,
    }


# ── Haversine ─────────────────────────────────────────────────────


class TestHaversine:
    def test_same_point_zero(self) -> None:
        assert _haversine(37.0, 127.0, 37.0, 127.0) == 0.0

    def test_known_distance(self) -> None:
        # Seoul to Incheon: ~27km
        dist = _haversine(37.5665, 126.978, 37.4563, 126.7052)
        assert 26_000 < dist < 28_000

    def test_short_distance(self) -> None:
        # ~111m (0.001 deg lat at equator)
        dist = _haversine(0.0, 0.0, 0.001, 0.0)
        assert 100 < dist < 120


# ── Off-Route Detection ──────────────────────────────────────────


class TestCheckOffRoute:
    def test_on_route(self) -> None:
        route = _sample_route_data()
        # At step 0 start location — should be on route
        assert check_off_route(37.5665, 126.978, route, 0) is False

    def test_off_route(self) -> None:
        route = _sample_route_data()
        # Far from both step start and end
        assert check_off_route(37.6, 127.1, route, 0) is True

    def test_empty_steps(self) -> None:
        route = RouteResult(
            steps=[],
            total_distance_meters=0,
            total_duration_seconds=0,
            overview_polyline="",
        ).model_dump()
        assert check_off_route(37.0, 127.0, route, 0) is False

    def test_step_index_beyond_steps(self) -> None:
        route = _sample_route_data()
        # Step index > total steps
        assert check_off_route(37.0, 127.0, route, 99) is False


# ── Navigation Service ───────────────────────────────────────────


class TestNavigationService:
    @pytest.mark.asyncio
    @patch(_CREATE_SESSION, new_callable=AsyncMock)
    @patch(_FIND_ACTIVE_FOR_UPDATE, new_callable=AsyncMock, return_value=None)
    async def test_start_navigation_success(
        self,
        mock_find_active: AsyncMock,
        mock_create: AsyncMock,
    ) -> None:
        from src.navigation.schemas import NavigationSessionCreate
        from src.navigation.service import start_navigation

        mock_create.return_value = _mock_nav_session()
        mock_map = AsyncMock()
        mock_map.geocode.return_value = [
            GeocodingResult(
                formatted_address="서울역",
                location=LatLng(lat=37.5547, lng=126.9706),
            )
        ]
        mock_map.get_directions.return_value = RouteResult(
            steps=[],
            total_distance_meters=1200,
            total_duration_seconds=900,
            overview_polyline="poly",
        )

        db = AsyncMock()
        payload = NavigationSessionCreate(
            host_id=TEST_HOST_ID,
            destination_query="서울역",
            origin_lat=37.5665,
            origin_lng=126.978,
        )

        result = await start_navigation(db, mock_map, payload)
        assert result.destination_name == "서울역"
        mock_map.geocode.assert_called_once()
        mock_map.get_directions.assert_called_once()

    @pytest.mark.asyncio
    @patch(_FIND_ACTIVE_FOR_UPDATE, new_callable=AsyncMock, return_value=None)
    async def test_start_navigation_geocode_fail(
        self,
        mock_find_active: AsyncMock,
    ) -> None:
        from src.navigation.schemas import NavigationSessionCreate
        from src.navigation.service import start_navigation

        mock_map = AsyncMock()
        mock_map.geocode.return_value = []

        db = AsyncMock()
        payload = NavigationSessionCreate(
            host_id=TEST_HOST_ID,
            destination_query="없는장소",
            origin_lat=37.5665,
            origin_lng=126.978,
        )

        with pytest.raises(ValueError, match="Could not geocode"):
            await start_navigation(db, mock_map, payload)


# ── AI Tools ─────────────────────────────────────────────────────


class TestStartNavigationTool:
    @pytest.fixture(autouse=True)
    def _clean(self) -> None:
        _clear_registry()

    @pytest.mark.asyncio
    async def test_missing_context(self) -> None:
        tool = StartNavigationTool()
        result = await tool.execute(destination="서울역")
        assert "error" in result

    @pytest.mark.asyncio
    async def test_empty_destination(self) -> None:
        tool = StartNavigationTool()
        ctx = _make_nav_context(map_provider=AsyncMock())
        result = await tool.execute(context=ctx, destination="  ")
        assert "error" in result

    @pytest.mark.asyncio
    async def test_no_map_provider(self) -> None:
        tool = StartNavigationTool()
        ctx = _make_nav_context(map_provider=None)
        result = await tool.execute(context=ctx, destination="서울역")
        assert "error" in result
        assert "Maps provider" in result["error"]

    @pytest.mark.asyncio
    @patch(
        "src.lib.ai.tools.start_navigation.service.start_navigation",
        new_callable=AsyncMock,
    )
    @patch(
        "src.lib.ai.tools.start_navigation.repository.find_latest_waypoint",
        new_callable=AsyncMock,
    )
    async def test_success(
        self,
        mock_latest: AsyncMock,
        mock_start: AsyncMock,
    ) -> None:
        mock_latest.return_value = _mock_waypoint()
        mock_start.return_value = _mock_nav_session()

        tool = StartNavigationTool()
        ctx = _make_nav_context(map_provider=AsyncMock())
        result = await tool.execute(context=ctx, destination="서울역")

        assert result["success"] is True
        assert "session_id" in result
        assert result["destination"] == "서울역"

    @pytest.mark.asyncio
    @patch(
        "src.lib.ai.tools.start_navigation.repository.find_latest_waypoint",
        new_callable=AsyncMock,
        return_value=None,
    )
    async def test_no_gps(self, mock_latest: AsyncMock) -> None:
        tool = StartNavigationTool()
        ctx = _make_nav_context(map_provider=AsyncMock())
        result = await tool.execute(context=ctx, destination="서울역")
        assert "error" in result
        assert "GPS" in result["error"]

    def test_declaration(self) -> None:
        tool = StartNavigationTool()
        decl = tool.to_declaration()
        assert decl["name"] == "start_navigation"
        assert "destination" in decl["parameters"]["properties"]
        assert decl["parameters"]["required"] == ["destination"]


class TestCancelNavigationTool:
    @pytest.fixture(autouse=True)
    def _clean(self) -> None:
        _clear_registry()

    @pytest.mark.asyncio
    async def test_missing_context(self) -> None:
        tool = CancelNavigationTool()
        result = await tool.execute()
        assert "error" in result

    @pytest.mark.asyncio
    @patch(
        "src.lib.ai.tools.cancel_navigation.repository.find_active_session",
        new_callable=AsyncMock,
        return_value=None,
    )
    async def test_no_active_session(self, mock_find: AsyncMock) -> None:
        tool = CancelNavigationTool()
        ctx = _make_nav_context()
        result = await tool.execute(context=ctx)
        assert "error" in result
        assert "No active" in result["error"]

    @pytest.mark.asyncio
    @patch(
        "src.lib.ai.tools.cancel_navigation.service.cancel_navigation",
        new_callable=AsyncMock,
    )
    @patch(
        "src.lib.ai.tools.cancel_navigation.repository.find_active_session",
        new_callable=AsyncMock,
    )
    async def test_success(
        self,
        mock_find: AsyncMock,
        mock_cancel: AsyncMock,
    ) -> None:
        mock_find.return_value = _mock_nav_session()
        tool = CancelNavigationTool()
        ctx = _make_nav_context()
        result = await tool.execute(context=ctx)

        assert result["success"] is True
        mock_cancel.assert_called_once()


class TestGetNavigationStepTool:
    @pytest.fixture(autouse=True)
    def _clean(self) -> None:
        _clear_registry()

    @pytest.mark.asyncio
    async def test_missing_context(self) -> None:
        tool = GetNavigationStepTool()
        result = await tool.execute()
        assert "error" in result

    @pytest.mark.asyncio
    @patch(
        "src.lib.ai.tools.get_navigation_step.repository.find_active_session",
        new_callable=AsyncMock,
        return_value=None,
    )
    async def test_no_active_session(self, mock_find: AsyncMock) -> None:
        tool = GetNavigationStepTool()
        ctx = _make_nav_context()
        result = await tool.execute(context=ctx)
        assert "error" in result

    @pytest.mark.asyncio
    @patch(
        "src.lib.ai.tools.get_navigation_step.repository.find_active_session",
        new_callable=AsyncMock,
    )
    async def test_success_step_0(self, mock_find: AsyncMock) -> None:
        mock_find.return_value = _mock_nav_session(step_index=0)
        tool = GetNavigationStepTool()
        ctx = _make_nav_context()
        result = await tool.execute(context=ctx)

        assert result["current_step"] == 1
        assert result["total_steps"] == 2
        assert result["instruction"] == "직진하세요"
        assert "next_instruction" in result
        assert result["next_instruction"] == "좌회전하세요"

    @pytest.mark.asyncio
    @patch(
        "src.lib.ai.tools.get_navigation_step.repository.find_active_session",
        new_callable=AsyncMock,
    )
    async def test_beyond_last_step(self, mock_find: AsyncMock) -> None:
        mock_find.return_value = _mock_nav_session(step_index=99)
        tool = GetNavigationStepTool()
        ctx = _make_nav_context()
        result = await tool.execute(context=ctx)

        assert "message" in result
        assert "completed all steps" in result["message"]

    def test_declaration(self) -> None:
        tool = GetNavigationStepTool()
        decl = tool.to_declaration()
        assert decl["name"] == "get_navigation_step"


# ── System Instruction ───────────────────────────────────────────


class TestSystemInstructionNavigation:
    def test_contains_navigation_rules(self) -> None:
        from src.lib.ai.orchestrator import DEFAULT_SYSTEM_INSTRUCTION

        assert "start_navigation" in DEFAULT_SYSTEM_INSTRUCTION
        assert "OFF-ROUTE" in DEFAULT_SYSTEM_INSTRUCTION
        assert "ARRIVAL" in DEFAULT_SYSTEM_INSTRUCTION
        assert "cancel_navigation" in DEFAULT_SYSTEM_INSTRUCTION
        assert "LOCATION AWARENESS" in DEFAULT_SYSTEM_INSTRUCTION


# ── Router (HTTP) ────────────────────────────────────────────────


class TestNavigationRouter:
    """Tests for navigation REST endpoints."""

    @patch(
        "src.navigation.router.service.start_navigation",
        new_callable=AsyncMock,
    )
    @patch(
        "src.navigation.router.authorize_host_access",
        new_callable=AsyncMock,
    )
    @patch("src.navigation.router.settings")
    def test_start_navigation_maps_not_configured(
        self,
        mock_settings: MagicMock,
        mock_auth: AsyncMock,
        mock_start: AsyncMock,
        authed_client: Any,
    ) -> None:
        mock_settings.maps_configured = False
        response = authed_client.post(
            "/api/v1/navigation/sessions",
            json={
                "host_id": str(TEST_HOST_ID),
                "destination_query": "서울역",
                "origin_lat": 37.5665,
                "origin_lng": 126.978,
            },
        )
        assert response.status_code == 503

    @patch(
        "src.navigation.router.repository.find_active_session",
        new_callable=AsyncMock,
        return_value=None,
    )
    @patch(
        "src.navigation.router.authorize_host_access",
        new_callable=AsyncMock,
    )
    def test_get_active_session_not_found(
        self,
        mock_auth: AsyncMock,
        mock_find: AsyncMock,
        authed_client: Any,
    ) -> None:
        response = authed_client.get(
            "/api/v1/navigation/sessions/active",
            params={"host_id": str(TEST_HOST_ID)},
        )
        assert response.status_code == 404

    @patch(
        "src.navigation.router.service.record_waypoint",
        new_callable=AsyncMock,
    )
    @patch(
        "src.navigation.router.authorize_host_access",
        new_callable=AsyncMock,
    )
    def test_create_waypoint(
        self,
        mock_auth: AsyncMock,
        mock_record: AsyncMock,
        authed_client: Any,
    ) -> None:
        mock_record.return_value = _mock_waypoint()
        response = authed_client.post(
            "/api/v1/navigation/waypoints",
            json={
                "host_id": str(TEST_HOST_ID),
                "lat": 37.5665,
                "lng": 126.978,
            },
        )
        assert response.status_code == 201
        data = response.json()
        assert data["lat"] == 37.5665

    @patch(
        "src.navigation.router.service.get_host_location",
        new_callable=AsyncMock,
    )
    @patch(
        "src.navigation.router.authorize_host_access",
        new_callable=AsyncMock,
    )
    def test_get_host_location_none(
        self,
        mock_auth: AsyncMock,
        mock_location: AsyncMock,
        authed_client: Any,
    ) -> None:
        mock_location.return_value = None
        response = authed_client.get(
            f"/api/v1/navigation/location/{TEST_HOST_ID}",
        )
        assert response.status_code == 200
        assert response.json() is None

    @patch(
        "src.navigation.router.service.record_waypoints_batch",
        new_callable=AsyncMock,
    )
    @patch(
        "src.navigation.router.authorize_host_access",
        new_callable=AsyncMock,
    )
    def test_batch_waypoints_validates_all_host_ids(
        self,
        mock_auth: AsyncMock,
        mock_batch: AsyncMock,
        authed_client: Any,
    ) -> None:
        """Batch waypoint endpoint must authorize every unique host_id."""
        other_host = uuid.UUID("00000000-0000-4000-8000-000000000002")
        mock_batch.return_value = [_mock_waypoint(), _mock_waypoint()]
        authed_client.post(
            "/api/v1/navigation/waypoints/batch",
            json=[
                {"host_id": str(TEST_HOST_ID), "lat": 37.5665, "lng": 126.978},
                {"host_id": str(other_host), "lat": 37.567, "lng": 126.979},
            ],
        )
        # authorize_host_access should be called once for each unique host_id
        assert mock_auth.call_count == 2

    @patch(
        "src.navigation.router.authorize_host_access",
        new_callable=AsyncMock,
    )
    def test_batch_waypoints_rejects_unauthorized_host(
        self,
        mock_auth: AsyncMock,
        authed_client: Any,
    ) -> None:
        """Batch with unauthorized host_id should return 403."""
        from fastapi import HTTPException

        other_host = uuid.UUID("00000000-0000-4000-8000-000000000002")
        mock_auth.side_effect = HTTPException(status_code=403, detail="Forbidden")
        response = authed_client.post(
            "/api/v1/navigation/waypoints/batch",
            json=[
                {"host_id": str(TEST_HOST_ID), "lat": 37.5665, "lng": 126.978},
                {"host_id": str(other_host), "lat": 37.567, "lng": 126.979},
            ],
        )
        assert response.status_code == 403
