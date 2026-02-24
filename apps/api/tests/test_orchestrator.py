from __future__ import annotations

from typing import Any
from unittest.mock import AsyncMock, MagicMock, patch

import pytest

from src.lib.ai.orchestrator import (
    _DEFAULT_MODELS,
    GeminiLiveOrchestrator,
    _resolve_model,
)

SETTINGS_PATH = "src.lib.ai.orchestrator.settings"


class TestResolveModel:
    """Tests for _resolve_model()."""

    @patch(SETTINGS_PATH)
    def test_env_override(self, mock_settings: MagicMock) -> None:
        mock_settings.GEMINI_LIVE_MODEL = "custom-model-override"
        mock_settings.GEMINI_BACKEND = "ai_studio"
        assert _resolve_model() == "custom-model-override"

    @patch(SETTINGS_PATH)
    def test_default_ai_studio(self, mock_settings: MagicMock) -> None:
        mock_settings.GEMINI_LIVE_MODEL = None
        mock_settings.GEMINI_BACKEND = "ai_studio"
        assert _resolve_model() == _DEFAULT_MODELS["ai_studio"]

    @patch(SETTINGS_PATH)
    def test_default_vertex_ai(self, mock_settings: MagicMock) -> None:
        mock_settings.GEMINI_LIVE_MODEL = None
        mock_settings.GEMINI_BACKEND = "vertex_ai"
        assert _resolve_model() == _DEFAULT_MODELS["vertex_ai"]


class TestBuildTools:
    """Tests for GeminiLiveOrchestrator._build_tools()."""

    def test_without_tool_definitions(self) -> None:
        orch = GeminiLiveOrchestrator(model="test-model")
        assert orch._build_tools() is None

    def test_with_tool_definitions(self) -> None:
        defns: list[dict[str, Any]] = [
            {
                "name": "test_tool",
                "description": "A test tool",
                "parameters": {
                    "type": "object",
                    "properties": {"key": {"type": "string"}},
                },
            }
        ]
        orch = GeminiLiveOrchestrator(model="test-model", tool_definitions=defns)
        tools = orch._build_tools()
        assert tools is not None
        assert len(tools) == 1


class TestHandleToolCall:
    """Tests for GeminiLiveOrchestrator.handle_tool_call()."""

    @pytest.mark.asyncio
    async def test_no_handler_returns_early(self) -> None:
        orch = GeminiLiveOrchestrator(model="test-model", tool_handler=None)
        mock_session = AsyncMock()
        mock_response = MagicMock()

        await orch.handle_tool_call(mock_session, mock_response)
        mock_session.send_tool_response.assert_not_called()

    @pytest.mark.asyncio
    async def test_no_tool_call_returns_early(self) -> None:
        """Response without tool_call should be a no-op."""

        async def mock_handler(name: str, args: dict[str, Any]) -> dict[str, str]:
            return {"status": "ok"}

        orch = GeminiLiveOrchestrator(
            model="test-model",
            tool_handler=mock_handler,
        )
        mock_session = AsyncMock()
        mock_response = MagicMock()
        mock_response.tool_call = None

        await orch.handle_tool_call(mock_session, mock_response)
        mock_session.send_tool_response.assert_not_called()

    @pytest.mark.asyncio
    async def test_success(self) -> None:
        handler_result = {"status": "ok"}

        async def mock_handler(name: str, args: dict[str, Any]) -> dict[str, str]:
            return handler_result

        orch = GeminiLiveOrchestrator(
            model="test-model",
            tool_handler=mock_handler,
        )

        mock_fc = MagicMock()
        mock_fc.name = "test_tool"
        mock_fc.args = {"key": "value"}
        mock_fc.id = "call-001"

        mock_tc = MagicMock()
        mock_tc.function_calls = [mock_fc]

        mock_response = MagicMock()
        mock_response.tool_call = mock_tc

        mock_session = AsyncMock()

        await orch.handle_tool_call(mock_session, mock_response)
        mock_session.send_tool_response.assert_called_once()

        # Verify keyword argument format
        call_kwargs = mock_session.send_tool_response.call_args.kwargs
        assert "function_responses" in call_kwargs
        fr_list = call_kwargs["function_responses"]
        assert len(fr_list) == 1
        assert fr_list[0].name == "test_tool"

    @pytest.mark.asyncio
    async def test_multiple_function_calls(self) -> None:
        """Multiple function calls in a single response should all be handled."""
        results: list[str] = []

        async def mock_handler(name: str, args: dict[str, Any]) -> dict[str, str]:
            results.append(name)
            return {"status": "ok"}

        orch = GeminiLiveOrchestrator(
            model="test-model",
            tool_handler=mock_handler,
        )

        fc1 = MagicMock()
        fc1.name = "tool_a"
        fc1.args = {}
        fc1.id = "call-001"

        fc2 = MagicMock()
        fc2.name = "tool_b"
        fc2.args = {"x": 1}
        fc2.id = "call-002"

        mock_tc = MagicMock()
        mock_tc.function_calls = [fc1, fc2]

        mock_response = MagicMock()
        mock_response.tool_call = mock_tc

        mock_session = AsyncMock()

        await orch.handle_tool_call(mock_session, mock_response)

        assert results == ["tool_a", "tool_b"]
        call_kwargs = mock_session.send_tool_response.call_args.kwargs
        assert len(call_kwargs["function_responses"]) == 2
