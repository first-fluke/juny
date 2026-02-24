"""Gemini function calling tool: scan and batch-register medications from camera."""

from datetime import datetime
from typing import Any

import structlog

from src.lib.ai.tools.base import BaseTool, ToolContext, register_tool
from src.medications.schemas import MedicationCreate
from src.medications.service import create_medication

logger = structlog.get_logger(__name__)


class ScanMedicationScheduleTool(BaseTool):
    """Batch-register medications from a scanned schedule."""

    @property
    def name(self) -> str:
        return "scan_medication_schedule"

    @property
    def description(self) -> str:
        return (
            "Batch-register medications extracted from a prescription, "
            "pharmacy label, or pill organizer visible in the camera. "
            "Pass ALL visible medication names and schedule times in a single call."
        )

    @property
    def parameters(self) -> dict[str, Any]:
        return {
            "type": "object",
            "properties": {
                "medications": {
                    "type": "array",
                    "items": {
                        "type": "object",
                        "properties": {
                            "pill_name": {
                                "type": "string",
                                "description": "Name of the medication.",
                            },
                            "schedule_time": {
                                "type": "string",
                                "description": (
                                    "ISO-8601 datetime when the medication "
                                    "should be taken."
                                ),
                            },
                        },
                        "required": ["pill_name", "schedule_time"],
                    },
                    "description": "List of medications to register.",
                },
                "source_description": {
                    "type": "string",
                    "description": (
                        "Optional description of the source "
                        "(e.g. 'prescription label', 'pill organizer')."
                    ),
                },
            },
            "required": ["medications"],
        }

    async def execute(
        self, *, context: ToolContext | None = None, **kwargs: Any
    ) -> Any:
        medications_raw: list[dict[str, str]] = kwargs.get("medications") or []
        source_description: str = kwargs.get("source_description") or ""

        if not context or "db" not in context or "host_id" not in context:
            return {"error": "Missing required context (db, host_id)"}

        if not medications_raw:
            return {"error": "medications list must not be empty"}

        db = context["db"]
        host_id = context["host_id"]

        created: list[dict[str, str]] = []
        errors: list[dict[str, str]] = []

        for idx, med in enumerate(medications_raw):
            pill_name = med.get("pill_name", "").strip()
            schedule_time_str = med.get("schedule_time", "")

            if not pill_name:
                errors.append(
                    {
                        "index": str(idx),
                        "error": "pill_name must not be empty",
                    }
                )
                continue

            try:
                schedule_time = datetime.fromisoformat(schedule_time_str)
            except (ValueError, TypeError):
                errors.append(
                    {
                        "index": str(idx),
                        "error": f"Invalid schedule_time format: {schedule_time_str}",
                    }
                )
                continue

            payload = MedicationCreate(
                host_id=host_id,
                pill_name=pill_name,
                schedule_time=schedule_time,
            )
            medication = await create_medication(db, payload)

            created.append(
                {
                    "medication_id": str(medication.id),
                    "pill_name": pill_name,
                    "schedule_time": schedule_time.isoformat(),
                }
            )

        logger.info(
            "medication_schedule_scanned",
            host_id=str(host_id),
            created_count=len(created),
            error_count=len(errors),
            source=source_description,
        )

        return {
            "success": len(created) > 0,
            "created_count": len(created),
            "created": created,
            "errors": errors,
        }


register_tool(ScanMedicationScheduleTool())
