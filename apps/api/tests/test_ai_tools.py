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
from src.lib.ai.tools.confirm_medication import ConfirmMedicationTool
from src.lib.ai.tools.log_wellness import LogWellnessTool
from src.lib.ai.tools.ping_tool import PingTool
from src.lib.ai.tools.register_medication import RegisterMedicationTool
from src.lib.ai.tools.scan_medication_schedule import ScanMedicationScheduleTool

_DISPATCH = "src.lib.ai.tools.log_wellness.dispatch_task"
_GET_TOKENS = "src.lib.ai.tools.log_wellness.get_user_token_strings"
_FIND_BY_HOST = "src.lib.ai.tools.log_wellness.relations_repo.find_by_host"
_CREATE_WELLNESS = "src.lib.ai.tools.log_wellness.create_wellness_log"
_CREATE_MED = "src.lib.ai.tools.register_medication.create_medication"
_CREATE_MED_SCAN = "src.lib.ai.tools.scan_medication_schedule.create_medication"
_FIND_MED_BY_NAME = "src.lib.ai.tools.confirm_medication.find_medication_by_pill_name"
_UPDATE_MED = "src.lib.ai.tools.confirm_medication.update_medication"


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

    def test_system_instruction_references_scan_medication_schedule(
        self,
    ) -> None:
        assert "scan_medication_schedule" in DEFAULT_SYSTEM_INSTRUCTION


class TestLogWellnessTool:
    @pytest.mark.asyncio
    @patch(_DISPATCH, new_callable=AsyncMock)
    @patch(_GET_TOKENS, new_callable=AsyncMock, return_value=[])
    @patch(_FIND_BY_HOST, new_callable=AsyncMock, return_value=([], 0))
    @patch(_CREATE_WELLNESS, new_callable=AsyncMock)
    async def test_log_wellness_success(
        self,
        mock_create: AsyncMock,
        mock_find: AsyncMock,
        mock_get_tokens: AsyncMock,
        mock_dispatch: AsyncMock,
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
        mock_dispatch.assert_not_called()

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
    @patch(_DISPATCH, new_callable=AsyncMock)
    @patch(_GET_TOKENS, new_callable=AsyncMock)
    @patch(_FIND_BY_HOST, new_callable=AsyncMock)
    @patch(_CREATE_WELLNESS, new_callable=AsyncMock)
    async def test_log_wellness_triggers_alert_on_emergency(
        self,
        mock_create: AsyncMock,
        mock_find: AsyncMock,
        mock_get_tokens: AsyncMock,
        mock_dispatch: AsyncMock,
    ) -> None:
        caregiver_id = uuid.UUID("00000000-0000-4000-8000-000000000010")
        mock_create.return_value = _mock_wellness_log()
        mock_find.return_value = (
            [MagicMock(caregiver_id=caregiver_id)],
            1,
        )
        mock_get_tokens.return_value = ["fcm-tok-cg1"]

        tool = LogWellnessTool()
        ctx = _make_db_context()

        await tool.execute(
            context=ctx,
            status="emergency",
            summary="Fall detected",
        )

        mock_dispatch.assert_called_once()
        args = mock_dispatch.call_args
        assert args[0][0] == "notification.send"
        data = args[0][1]
        assert data["tokens"] == ["fcm-tok-cg1"]
        assert data["title"] == "Wellness Alert: EMERGENCY"
        assert data["body"] == "Fall detected"
        assert data["data"]["host_id"] == str(ctx["host_id"])

    @pytest.mark.asyncio
    @patch(_DISPATCH, new_callable=AsyncMock)
    @patch(_GET_TOKENS, new_callable=AsyncMock)
    @patch(_FIND_BY_HOST, new_callable=AsyncMock)
    @patch(_CREATE_WELLNESS, new_callable=AsyncMock)
    async def test_log_wellness_triggers_alert_on_warning(
        self,
        mock_create: AsyncMock,
        mock_find: AsyncMock,
        mock_get_tokens: AsyncMock,
        mock_dispatch: AsyncMock,
    ) -> None:
        cg1 = uuid.UUID("00000000-0000-4000-8000-000000000011")
        cg2 = uuid.UUID("00000000-0000-4000-8000-000000000012")
        mock_create.return_value = _mock_wellness_log()
        mock_find.return_value = (
            [MagicMock(caregiver_id=cg1), MagicMock(caregiver_id=cg2)],
            2,
        )
        mock_get_tokens.side_effect = [["tok-cg1"], ["tok-cg2"]]

        tool = LogWellnessTool()
        ctx = _make_db_context()

        await tool.execute(
            context=ctx,
            status="warning",
            summary="Skipped meal",
        )

        mock_dispatch.assert_called_once()
        data = mock_dispatch.call_args[0][1]
        assert set(data["tokens"]) == {"tok-cg1", "tok-cg2"}

    @pytest.mark.asyncio
    @patch(_DISPATCH, new_callable=AsyncMock)
    @patch(_FIND_BY_HOST, new_callable=AsyncMock)
    @patch(_CREATE_WELLNESS, new_callable=AsyncMock)
    async def test_log_wellness_no_alert_on_normal(
        self,
        mock_create: AsyncMock,
        mock_find: AsyncMock,
        mock_dispatch: AsyncMock,
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
        mock_dispatch.assert_not_called()

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


class TestScanMedicationScheduleTool:
    @pytest.mark.asyncio
    @patch(_CREATE_MED_SCAN, new_callable=AsyncMock)
    async def test_scan_success_multiple_medications(
        self, mock_create: AsyncMock
    ) -> None:
        med_ids = [
            uuid.UUID("00000000-0000-4000-8000-000000000004"),
            uuid.UUID("00000000-0000-4000-8000-000000000005"),
            uuid.UUID("00000000-0000-4000-8000-000000000006"),
        ]
        mock_create.side_effect = [_mock_medication(m) for m in med_ids]
        tool = ScanMedicationScheduleTool()
        ctx = _make_db_context()

        result = await tool.execute(
            context=ctx,
            medications=[
                {"pill_name": "Aspirin 100mg", "schedule_time": "2026-03-01T09:00:00"},
                {"pill_name": "Amlodipine 5mg", "schedule_time": "2026-03-01T12:00:00"},
                {
                    "pill_name": "Metformin 500mg",
                    "schedule_time": "2026-03-01T18:00:00",
                },
            ],
        )

        assert result["success"] is True
        assert result["created_count"] == 3
        assert len(result["created"]) == 3
        assert len(result["errors"]) == 0
        assert mock_create.call_count == 3

    @pytest.mark.asyncio
    async def test_scan_empty_medications(self) -> None:
        tool = ScanMedicationScheduleTool()
        ctx = _make_db_context()
        result = await tool.execute(context=ctx, medications=[])
        assert "error" in result
        assert "empty" in result["error"]

    @pytest.mark.asyncio
    async def test_scan_missing_context(self) -> None:
        tool = ScanMedicationScheduleTool()
        result = await tool.execute(
            medications=[
                {"pill_name": "Aspirin", "schedule_time": "2026-03-01T09:00:00"},
            ],
        )
        assert "error" in result

    @pytest.mark.asyncio
    @patch(_CREATE_MED_SCAN, new_callable=AsyncMock)
    async def test_scan_partial_failure(self, mock_create: AsyncMock) -> None:
        mock_create.return_value = _mock_medication()
        tool = ScanMedicationScheduleTool()
        ctx = _make_db_context()

        result = await tool.execute(
            context=ctx,
            medications=[
                {"pill_name": "Aspirin 100mg", "schedule_time": "2026-03-01T09:00:00"},
                {"pill_name": "Bad Med", "schedule_time": "not-a-date"},
                {"pill_name": "  ", "schedule_time": "2026-03-01T12:00:00"},
            ],
        )

        assert result["success"] is True
        assert result["created_count"] == 1
        assert len(result["errors"]) == 2
        mock_create.assert_called_once()

    def test_scan_declaration(self) -> None:
        tool = ScanMedicationScheduleTool()
        decl = tool.to_declaration()
        assert decl["name"] == "scan_medication_schedule"
        assert "parameters" in decl
        assert "medications" in decl["parameters"]["properties"]
        assert decl["parameters"]["required"] == ["medications"]


class TestConfirmMedicationTool:
    @pytest.mark.asyncio
    @patch(_UPDATE_MED, new_callable=AsyncMock)
    @patch(_FIND_MED_BY_NAME, new_callable=AsyncMock)
    async def test_confirm_success(
        self, mock_find: AsyncMock, mock_update: AsyncMock
    ) -> None:
        med = _mock_medication()
        med.pill_name = "Aspirin"
        med.taken_at = "2026-03-01T09:30:00+00:00"
        mock_find.return_value = med
        mock_update.return_value = med

        tool = ConfirmMedicationTool()
        ctx = _make_db_context()

        result = await tool.execute(context=ctx, pill_name="Aspirin")

        assert result["success"] is True
        assert result["pill_name"] == "Aspirin"
        assert "medication_id" in result
        mock_find.assert_called_once()
        mock_update.assert_called_once()

    @pytest.mark.asyncio
    @patch(_FIND_MED_BY_NAME, new_callable=AsyncMock)
    async def test_confirm_not_found(self, mock_find: AsyncMock) -> None:
        mock_find.return_value = None
        tool = ConfirmMedicationTool()
        ctx = _make_db_context()

        result = await tool.execute(context=ctx, pill_name="Unknown")

        assert "error" in result
        assert "No untaken medication" in result["error"]

    @pytest.mark.asyncio
    async def test_confirm_missing_context(self) -> None:
        tool = ConfirmMedicationTool()
        result = await tool.execute(pill_name="Aspirin")
        assert "error" in result

    @pytest.mark.asyncio
    async def test_confirm_empty_pill_name(self) -> None:
        tool = ConfirmMedicationTool()
        ctx = _make_db_context()
        result = await tool.execute(context=ctx, pill_name="  ")
        assert "error" in result

    def test_confirm_declaration(self) -> None:
        tool = ConfirmMedicationTool()
        decl = tool.to_declaration()
        assert decl["name"] == "confirm_medication"
        assert "parameters" in decl
        assert "pill_name" in decl["parameters"]["properties"]
        assert decl["parameters"]["required"] == ["pill_name"]
