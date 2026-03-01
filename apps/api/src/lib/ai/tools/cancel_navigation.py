"""Gemini function calling tool: cancel current navigation."""

from typing import Any

import structlog

from src.lib.ai.tools.base import BaseTool, ToolContext, register_tool
from src.navigation import repository, service

logger = structlog.get_logger(__name__)


class CancelNavigationTool(BaseTool):
    """AI tool to cancel the current walking navigation session."""

    @property
    def name(self) -> str:
        return "cancel_navigation"

    @property
    def description(self) -> str:
        return (
            "Cancel the current navigation. "
            "Use when the Host says to stop directions or has arrived."
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

        await service.cancel_navigation(db, nav.id)

        logger.info(
            "navigation_cancelled",
            host_id=str(host_id),
            session_id=str(nav.id),
        )

        return {
            "success": True,
            "session_id": str(nav.id),
            "message": "Navigation cancelled",
        }


register_tool(CancelNavigationTool())
