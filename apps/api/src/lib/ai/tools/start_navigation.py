"""Gemini function calling tool: start walking navigation."""

from typing import Any

import structlog

from src.lib.ai.tools.base import BaseTool, ToolContext, register_tool
from src.lib.maps.base import MapProvider
from src.navigation import repository, service
from src.navigation.schemas import NavigationSessionCreate

logger = structlog.get_logger(__name__)


class StartNavigationTool(BaseTool):
    """AI tool to start walking navigation to a spoken destination."""

    @property
    def name(self) -> str:
        return "start_navigation"

    @property
    def description(self) -> str:
        return (
            "Start walking navigation to a destination. "
            "Use when the Host says where they want to go."
        )

    @property
    def parameters(self) -> dict[str, Any]:
        return {
            "type": "object",
            "properties": {
                "destination": {
                    "type": "string",
                    "description": "Destination name or address.",
                },
            },
            "required": ["destination"],
        }

    async def execute(
        self, *, context: ToolContext | None = None, **kwargs: Any
    ) -> Any:
        destination: str = kwargs.get("destination", "")

        if not context or "db" not in context or "host_id" not in context:
            return {"error": "Missing required context (db, host_id)"}

        if not destination.strip():
            return {"error": "destination must not be empty"}

        map_provider: MapProvider | None = context.get("map_provider")
        if map_provider is None:
            return {"error": "Maps provider is not configured"}

        db = context["db"]
        host_id = context["host_id"]

        # Get current location from latest waypoint
        latest = await repository.find_latest_waypoint(db, host_id)
        if latest is None:
            return {
                "error": "No GPS location available. Please enable location sharing.",
            }

        payload = NavigationSessionCreate(
            host_id=host_id,
            destination_query=destination.strip(),
            origin_lat=latest.lat,
            origin_lng=latest.lng,
        )

        try:
            nav = await service.start_navigation(db, map_provider, payload)
        except ValueError as e:
            return {"error": str(e)}

        route_data = nav.route_data
        steps = route_data.get("steps", [])
        first_instruction = steps[0]["instruction"] if steps else ""

        logger.info(
            "navigation_started",
            host_id=str(host_id),
            session_id=str(nav.id),
            destination=nav.destination_name,
        )

        return {
            "success": True,
            "session_id": str(nav.id),
            "destination": nav.destination_name,
            "total_distance_meters": route_data.get("total_distance_meters", 0),
            "total_duration_seconds": route_data.get("total_duration_seconds", 0),
            "first_instruction": first_instruction,
            "total_steps": len(steps),
        }


register_tool(StartNavigationTool())
