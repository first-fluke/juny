"""Gemini function calling tool: register a medication schedule."""

from datetime import datetime
from typing import Any

import structlog

from src.lib.ai.tools.base import BaseTool, ToolContext, register_tool
from src.medications.schemas import MedicationCreate
from src.medications.service import create_medication

logger = structlog.get_logger(__name__)


class RegisterMedicationTool(BaseTool):
    """Gemini function calling tool: register a medication schedule."""

    @property
    def name(self) -> str:
        return "register_medication"

    @property
    def description(self) -> str:
        return (
            "Register a medication schedule entry for the host. "
            "Use when the host mentions taking medicine or when "
            "a caregiver sets up a medication reminder."
        )

    @property
    def parameters(self) -> dict[str, Any]:
        return {
            "type": "object",
            "properties": {
                "pill_name": {
                    "type": "string",
                    "description": "Name of the medication.",
                },
                "schedule_time": {
                    "type": "string",
                    "description": (
                        "ISO-8601 datetime when the medication should be taken."
                    ),
                },
            },
            "required": ["pill_name", "schedule_time"],
        }

    async def execute(
        self, *, context: ToolContext | None = None, **kwargs: Any
    ) -> Any:
        pill_name: str = kwargs.get("pill_name", "")
        schedule_time_str: str = kwargs.get("schedule_time", "")

        if not context or "db" not in context or "host_id" not in context:
            return {"error": "Missing required context (db, host_id)"}

        if not pill_name.strip():
            return {"error": "pill_name must not be empty"}

        try:
            schedule_time = datetime.fromisoformat(schedule_time_str)
        except (ValueError, TypeError):
            return {
                "error": (f"Invalid schedule_time format: {schedule_time_str}"),
            }

        db = context["db"]
        host_id = context["host_id"]

        payload = MedicationCreate(
            host_id=host_id,
            pill_name=pill_name.strip(),
            schedule_time=schedule_time,
        )
        medication = await create_medication(db, payload)

        logger.info(
            "medication_registered",
            host_id=str(host_id),
            pill_name=pill_name,
            medication_id=str(medication.id),
        )

        return {
            "success": True,
            "medication_id": str(medication.id),
            "pill_name": pill_name,
            "schedule_time": schedule_time.isoformat(),
        }


register_tool(RegisterMedicationTool())
