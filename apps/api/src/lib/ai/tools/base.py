import importlib
import pkgutil
from abc import ABC, abstractmethod
from collections.abc import Callable, Coroutine
from typing import Any

ToolContext = dict[str, Any]
ToolHandler = Callable[[str, dict[str, Any]], Coroutine[Any, Any, Any]]

_registry: dict[str, "BaseTool"] = {}


class BaseTool(ABC):
    """Abstract base class for Gemini function calling tools."""

    @property
    @abstractmethod
    def name(self) -> str: ...

    @property
    @abstractmethod
    def description(self) -> str: ...

    @property
    def parameters(self) -> dict[str, Any]:
        return {}

    @abstractmethod
    async def execute(
        self, *, context: ToolContext | None = None, **kwargs: Any
    ) -> Any: ...

    def to_declaration(self) -> dict[str, Any]:
        """Convert to Gemini function declaration dict."""
        decl: dict[str, Any] = {
            "name": self.name,
            "description": self.description,
        }
        if self.parameters:
            decl["parameters"] = self.parameters
        return decl


def register_tool(tool: BaseTool) -> None:
    """Register a tool in the global registry."""
    _registry[tool.name] = tool


def get_tool_definitions() -> list[dict[str, Any]]:
    """Return all registered tool declarations."""
    _ensure_tools_loaded()
    return [tool.to_declaration() for tool in _registry.values()]


def get_tool_handler(context: ToolContext | None = None) -> ToolHandler:
    """Return an async callable that dispatches to the correct tool.

    Args:
        context: Shared context dict (e.g. {"db": AsyncSession, "host_id": UUID}).
                 Passed to every tool's execute() method.
    """
    _ensure_tools_loaded()

    async def handler(name: str, args: dict[str, Any]) -> Any:
        tool = _registry.get(name)
        if tool is None:
            return {"error": f"Unknown tool: {name}"}
        return await tool.execute(context=context, **args)

    return handler


def _ensure_tools_loaded() -> None:
    """Auto-discover and import all tool modules in this package."""
    import src.lib.ai.tools as tools_pkg

    for _importer, modname, _ispkg in pkgutil.iter_modules(tools_pkg.__path__):
        if modname == "base":
            continue
        importlib.import_module(f"src.lib.ai.tools.{modname}")


def _clear_registry() -> None:
    """Clear all registered tools. For testing only."""
    _registry.clear()
