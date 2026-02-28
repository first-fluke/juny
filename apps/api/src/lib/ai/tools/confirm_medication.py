"""Gemini function calling tool: confirm medication intake."""

from typing import Any

import structlog

from src.lib.ai.tools.base import BaseTool, ToolContext, register_tool
from src.medications.schemas import MedicationUpdate
from src.medications.service import find_medication_by_pill_name, update_medication

logger = structlog.get_logger(__name__)


class ConfirmMedicationTool(BaseTool):
    """AI tool to mark a medication as taken by pill name."""

    @property
    def name(self) -> str:
        return "confirm_medication"

    @property
    def description(self) -> str:
        return (
            "Mark a medication as taken. Use when the Host confirms "
            "they have taken a specific medication."
        )

    @property
    def parameters(self) -> dict[str, Any]:
        return {
            "type": "object",
            "properties": {
                "pill_name": {
                    "type": "string",
                    "description": "Name of the medication the host has taken.",
                },
            },
            "required": ["pill_name"],
        }

    async def execute(
        self, *, context: ToolContext | None = None, **kwargs: Any
    ) -> Any:
        pill_name: str = kwargs.get("pill_name", "")

        if not context or "db" not in context or "host_id" not in context:
            return {"error": "Missing required context (db, host_id)"}

        if not pill_name.strip():
            return {"error": "pill_name must not be empty"}

        db = context["db"]
        host_id = context["host_id"]

        medication = await find_medication_by_pill_name(db, host_id, pill_name)
        if medication is None:
            return {
                "error": f"No untaken medication matching '{pill_name}' found",
            }

        updated = await update_medication(
            db, medication, MedicationUpdate(is_taken=True)
        )

        logger.info(
            "medication_confirmed",
            host_id=str(host_id),
            medication_id=str(updated.id),
            pill_name=updated.pill_name,
        )

        return {
            "success": True,
            "medication_id": str(updated.id),
            "pill_name": updated.pill_name,
            "taken_at": str(updated.taken_at),
        }


register_tool(ConfirmMedicationTool())
