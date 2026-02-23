import uuid
from typing import Any
from unittest.mock import AsyncMock, MagicMock, patch

import pytest

from src.lib.ai.orchestrator import DEFAULT_SYSTEM_INSTRUCTION
from src.lib.ai.tools.base import (
    _clear_registry,
    _registry,
    get_tool_definitions,
    get_tool_handler,
    register_tool,
)
from src.lib.ai.tools.log_wellness import LogWellnessTool
from src.lib.ai.tools.ping_tool import PingTool
from src.lib.ai.tools.register_medication import RegisterMedicationTool

_NOTIFY = "src.lib.ai.tools.log_wellness.send_push_notification"
_FIND_BY_HOST = "src.lib.ai.tools.log_wellness.relations_repo.find_by_host"
_CREATE_WELLNESS = "src.lib.ai.tools.log_wellness.create_wellness_log"
_CREATE_MED = "src.lib.ai.tools.register_medication.create_medication"


@pytest.fixture(autouse=True)
def _clean_registry() -> None:
    """Clear the tool registry before each test."""
    _clear_registry()


def _make_db_context() -> dict[str, Any]:
    """Create a mock DB context for tool testing."""
    return {
        "db": AsyncMock(),
        "host_id": uuid.UUID("00000000-0000-4000-8000-000000000001"),
    }


def _mock_wellness_log(
    log_id: uuid.UUID | None = None,
) -> MagicMock:
    mock = MagicMock()
    mock.id = log_id or uuid.UUID("00000000-0000-4000-8000-000000000002")
    return mock


def _mock_medication(
    med_id: uuid.UUID | None = None,
) -> MagicMock:
    mock = MagicMock()
    mock.id = med_id or uuid.UUID("00000000-0000-4000-8000-000000000003")
    return mock


class TestToolRegistry:
    def test_register_tool(self) -> None:
        tool = PingTool()
        register_tool(tool)
        assert "ping" in _registry
        assert _registry["ping"] is tool

    def test_to_declaration(self) -> None:
        tool = PingTool()
        decl = tool.to_declaration()
        assert decl["name"] == "ping"
        assert decl["description"] == "returns pong"
        assert "parameters" not in decl

    def test_get_tool_definitions(self) -> None:
        register_tool(PingTool())
        defs = get_tool_definitions()
        assert len(defs) >= 1
        names = [d["name"] for d in defs]
        assert "ping" in names

    @pytest.mark.asyncio
    async def test_get_tool_handler_dispatches(self) -> None:
        register_tool(PingTool())
        handler = get_tool_handler()
        result = await handler("ping", {})
        assert result == "pong"

    @pytest.mark.asyncio
    async def test_get_tool_handler_unknown_tool(self) -> None:
        handler = get_tool_handler()
        result = await handler("nonexistent", {})
        assert isinstance(result, dict)
        assert "error" in result

    @pytest.mark.asyncio
    async def test_ping_tool_execute(self) -> None:
        tool = PingTool()
        result = await tool.execute()
        assert result == "pong"

    @pytest.mark.asyncio
    async def test_handler_passes_context(self) -> None:
        ctx = _make_db_context()
        tool = MagicMock(spec=PingTool)
        tool.name = "mock_tool"
        tool.execute = AsyncMock(return_value="ok")
        register_tool(tool)

        handler = get_tool_handler(context=ctx)
        result = await handler("mock_tool", {"arg1": "val1"})

        assert result == "ok"
        tool.execute.assert_called_once_with(context=ctx, arg1="val1")


class TestAIPersona:
    def test_system_instruction_contains_juny(self) -> None:
        assert "juny" in DEFAULT_SYSTEM_INSTRUCTION.lower()

    def test_system_instruction_contains_concierge_spotter(
        self,
    ) -> None:
        assert "Concierge/Spotter" in DEFAULT_SYSTEM_INSTRUCTION

    def test_system_instruction_references_log_wellness(
        self,
    ) -> None:
        assert "log_wellness" in DEFAULT_SYSTEM_INSTRUCTION

    def test_system_instruction_references_register_medication(
        self,
    ) -> None:
        assert "register_medication" in DEFAULT_SYSTEM_INSTRUCTION

    def test_system_instruction_mentions_emergency(self) -> None:
        assert "emergency" in DEFAULT_SYSTEM_INSTRUCTION


class TestLogWellnessTool:
    @pytest.mark.asyncio
    @patch(_FIND_BY_HOST, new_callable=AsyncMock, return_value=[])
    @patch(_NOTIFY, new_callable=AsyncMock)
    @patch(_CREATE_WELLNESS, new_callable=AsyncMock)
    async def test_log_wellness_success(
        self,
        mock_create: AsyncMock,
        mock_notify: AsyncMock,
        mock_find: AsyncMock,
    ) -> None:
        mock_create.return_value = _mock_wellness_log()
        tool = LogWellnessTool()
        ctx = _make_db_context()

        result = await tool.execute(
            context=ctx,
            status="warning",
            summary="User appeared dizzy",
            details={"location": "kitchen"},
        )

        assert result["success"] is True
        assert result["status"] == "warning"
        assert result["summary"] == "User appeared dizzy"
        assert "log_id" in result
        mock_create.assert_called_once()
        mock_find.assert_called_once()
        mock_notify.assert_not_called()

    @pytest.mark.asyncio
    async def test_log_wellness_missing_context(self) -> None:
        tool = LogWellnessTool()
        result = await tool.execute(status="normal", summary="All good")
        assert "error" in result

    @pytest.mark.asyncio
    async def test_log_wellness_invalid_status(self) -> None:
        tool = LogWellnessTool()
        ctx = _make_db_context()
        result = await tool.execute(context=ctx, status="invalid", summary="test")
        assert "error" in result
        assert "Invalid status" in result["error"]

    @pytest.mark.asyncio
    async def test_log_wellness_empty_summary(self) -> None:
        tool = LogWellnessTool()
        ctx = _make_db_context()
        result = await tool.execute(context=ctx, status="normal", summary="  ")
        assert "error" in result

    @pytest.mark.asyncio
    @patch(_NOTIFY, new_callable=AsyncMock)
    @patch(_FIND_BY_HOST, new_callable=AsyncMock)
    @patch(_CREATE_WELLNESS, new_callable=AsyncMock)
    async def test_log_wellness_triggers_alert_on_emergency(
        self,
        mock_create: AsyncMock,
        mock_find: AsyncMock,
        mock_notify: AsyncMock,
    ) -> None:
        caregiver_id = uuid.UUID("00000000-0000-4000-8000-000000000010")
        mock_create.return_value = _mock_wellness_log()
        mock_find.return_value = [
            MagicMock(caregiver_id=caregiver_id),
        ]

        tool = LogWellnessTool()
        ctx = _make_db_context()

        await tool.execute(
            context=ctx,
            status="emergency",
            summary="Fall detected",
        )

        mock_notify.assert_called_once()
        kw = mock_notify.call_args.kwargs
        assert kw["recipient_id"] == caregiver_id
        assert kw["title"] == "Wellness Alert: EMERGENCY"
        assert kw["body"] == "Fall detected"
        assert kw["data"]["host_id"] == str(ctx["host_id"])

    @pytest.mark.asyncio
    @patch(_NOTIFY, new_callable=AsyncMock)
    @patch(_FIND_BY_HOST, new_callable=AsyncMock)
    @patch(_CREATE_WELLNESS, new_callable=AsyncMock)
    async def test_log_wellness_triggers_alert_on_warning(
        self,
        mock_create: AsyncMock,
        mock_find: AsyncMock,
        mock_notify: AsyncMock,
    ) -> None:
        cg1 = uuid.UUID("00000000-0000-4000-8000-000000000011")
        cg2 = uuid.UUID("00000000-0000-4000-8000-000000000012")
        mock_create.return_value = _mock_wellness_log()
        mock_find.return_value = [
            MagicMock(caregiver_id=cg1),
            MagicMock(caregiver_id=cg2),
        ]

        tool = LogWellnessTool()
        ctx = _make_db_context()

        await tool.execute(
            context=ctx,
            status="warning",
            summary="Skipped meal",
        )

        assert mock_notify.call_count == 2
        recipients = {c.kwargs["recipient_id"] for c in mock_notify.call_args_list}
        assert recipients == {cg1, cg2}

    @pytest.mark.asyncio
    @patch(_NOTIFY, new_callable=AsyncMock)
    @patch(_FIND_BY_HOST, new_callable=AsyncMock)
    @patch(_CREATE_WELLNESS, new_callable=AsyncMock)
    async def test_log_wellness_no_alert_on_normal(
        self,
        mock_create: AsyncMock,
        mock_find: AsyncMock,
        mock_notify: AsyncMock,
    ) -> None:
        mock_create.return_value = _mock_wellness_log()
        tool = LogWellnessTool()
        ctx = _make_db_context()

        await tool.execute(
            context=ctx,
            status="normal",
            summary="All good",
        )

        mock_create.assert_called_once()
        mock_find.assert_not_called()
        mock_notify.assert_not_called()

    def test_log_wellness_declaration(self) -> None:
        tool = LogWellnessTool()
        decl = tool.to_declaration()
        assert decl["name"] == "log_wellness"
        assert "parameters" in decl
        assert "status" in decl["parameters"]["properties"]
        assert "summary" in decl["parameters"]["properties"]
        assert decl["parameters"]["required"] == [
            "status",
            "summary",
        ]


class TestRegisterMedicationTool:
    @pytest.mark.asyncio
    @patch(_CREATE_MED, new_callable=AsyncMock)
    async def test_register_medication_success(self, mock_create: AsyncMock) -> None:
        mock_create.return_value = _mock_medication()
        tool = RegisterMedicationTool()
        ctx = _make_db_context()

        result = await tool.execute(
            context=ctx,
            pill_name="Aspirin",
            schedule_time="2026-03-01T09:00:00+09:00",
        )

        assert result["success"] is True
        assert result["pill_name"] == "Aspirin"
        assert "medication_id" in result
        assert "2026-03-01" in result["schedule_time"]
        mock_create.assert_called_once()

    @pytest.mark.asyncio
    async def test_register_medication_missing_context(
        self,
    ) -> None:
        tool = RegisterMedicationTool()
        result = await tool.execute(
            pill_name="Aspirin",
            schedule_time="2026-03-01T09:00:00",
        )
        assert "error" in result

    @pytest.mark.asyncio
    async def test_register_medication_empty_pill_name(
        self,
    ) -> None:
        tool = RegisterMedicationTool()
        ctx = _make_db_context()
        result = await tool.execute(
            context=ctx,
            pill_name="  ",
            schedule_time="2026-03-01T09:00:00",
        )
        assert "error" in result

    @pytest.mark.asyncio
    async def test_register_medication_invalid_time(
        self,
    ) -> None:
        tool = RegisterMedicationTool()
        ctx = _make_db_context()
        result = await tool.execute(
            context=ctx,
            pill_name="Aspirin",
            schedule_time="not-a-date",
        )
        assert "error" in result
        assert "Invalid schedule_time" in result["error"]

    def test_register_medication_declaration(self) -> None:
        tool = RegisterMedicationTool()
        decl = tool.to_declaration()
        assert decl["name"] == "register_medication"
        assert "parameters" in decl
        assert "pill_name" in decl["parameters"]["properties"]
        assert "schedule_time" in decl["parameters"]["properties"]
        assert decl["parameters"]["required"] == [
            "pill_name",
            "schedule_time",
        ]
