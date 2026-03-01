"""Gemini function calling tool: get current navigation step."""

from typing import Any

import structlog

from src.lib.ai.tools.base import BaseTool, ToolContext, register_tool
from src.navigation import repository

logger = structlog.get_logger(__name__)


class GetNavigationStepTool(BaseTool):
    """AI tool to retrieve the current or next navigation step."""

    @property
    def name(self) -> str:
        return "get_navigation_step"

    @property
    def description(self) -> str:
        return (
            "Get the current or next navigation instruction. "
            "Use when the Host asks about the next turn or direction."
        )

    async def execute(
        self, *, context: ToolContext | None = None, **kwargs: Any
    ) -> Any:
        if not context or "db" not in context or "host_id" not in context:
            return {"error": "Missing required context (db, host_id)"}

        db = context["db"]
        host_id = context["host_id"]

        nav = await repository.find_active_session(db, host_id)
        if nav is None:
            return {"error": "No active navigation session"}

        route_data = nav.route_data
        steps = route_data.get("steps", [])
        idx = nav.current_step_index

        if not steps:
            return {"error": "No route steps available"}

        if idx >= len(steps):
            return {
                "message": "You have completed all steps. "
                "You should be at your destination.",
                "destination": nav.destination_name,
            }

        current_step = steps[idx]
        remaining_steps = len(steps) - idx

        result: dict[str, Any] = {
            "current_step": idx + 1,
            "total_steps": len(steps),
            "remaining_steps": remaining_steps,
            "instruction": current_step.get("instruction", ""),
            "distance_meters": current_step.get("distance_meters", 0),
            "maneuver": current_step.get("maneuver"),
            "destination": nav.destination_name,
        }

        # Include next step preview if available
        if idx + 1 < len(steps):
            next_step = steps[idx + 1]
            result["next_instruction"] = next_step.get("instruction", "")
            result["next_maneuver"] = next_step.get("maneuver")

        return result


register_tool(GetNavigationStepTool())
