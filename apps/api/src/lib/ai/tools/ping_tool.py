from typing import Any

from src.lib.ai.tools.base import BaseTool, ToolContext, register_tool
from src.lib.config import settings


class PingTool(BaseTool):
    @property
    def name(self) -> str:
        return "ping"

    @property
    def description(self) -> str:
        return "returns pong"

    async def execute(
        self, *, context: ToolContext | None = None, **kwargs: Any
    ) -> str:
        return "pong"


if settings.PROJECT_ENV != "prod":
    register_tool(PingTool())
