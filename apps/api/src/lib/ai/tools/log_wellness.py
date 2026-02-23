"""Gemini function calling tool: log a wellness observation."""

from typing import Any

import structlog

from src.common.enums import WellnessStatus
from src.lib.ai.tools.base import BaseTool, ToolContext, register_tool
from src.lib.notifications import send_push_notification
from src.relations import repository as relations_repo
from src.wellness.schemas import WellnessLogCreate
from src.wellness.service import create_wellness_log

logger = structlog.get_logger(__name__)

_VALID_STATUSES = {s.value for s in WellnessStatus}


class LogWellnessTool(BaseTool):
    """Gemini function calling tool: log a wellness observation."""

    @property
    def name(self) -> str:
        return "log_wellness"

    @property
    def description(self) -> str:
        return (
            "Log a wellness observation for the host. "
            "Use when you detect a notable health or safety event "
            "(e.g. fall, confusion, normal check-in)."
        )

    @property
    def parameters(self) -> dict[str, Any]:
        return {
            "type": "object",
            "properties": {
                "status": {
                    "type": "string",
                    "enum": ["normal", "warning", "emergency"],
                    "description": "Severity level of the observation.",
                },
                "summary": {
                    "type": "string",
                    "description": (
                        "Human-readable summary of the wellness observation."
                    ),
                },
                "details": {
                    "type": "object",
                    "description": (
                        "Optional structured details (e.g. vital signs, context)."
                    ),
                },
            },
            "required": ["status", "summary"],
        }

    async def execute(
        self, *, context: ToolContext | None = None, **kwargs: Any
    ) -> Any:
        status_val: str = kwargs.get("status", "")
        summary: str = kwargs.get("summary", "")
        details: dict[str, Any] = kwargs.get("details") or {}

        if not context or "db" not in context or "host_id" not in context:
            return {"error": "Missing required context (db, host_id)"}

        if status_val not in _VALID_STATUSES:
            return {
                "error": (
                    f"Invalid status: {status_val}. Must be one of {_VALID_STATUSES}"
                ),
            }

        if not summary.strip():
            return {"error": "summary must not be empty"}

        db = context["db"]
        host_id = context["host_id"]

        payload = WellnessLogCreate(
            host_id=host_id,
            status=WellnessStatus(status_val),
            summary=summary,
            details=details,
        )
        log_entry = await create_wellness_log(db, payload)

        logger.info(
            "wellness_logged",
            host_id=str(host_id),
            status=status_val,
            log_id=str(log_entry.id),
        )

        # Alert caregivers on warning/emergency
        if status_val in {"warning", "emergency"}:
            relations = await relations_repo.find_by_host(db, host_id)
            for rel in relations:
                await send_push_notification(
                    recipient_id=rel.caregiver_id,
                    title=f"Wellness Alert: {status_val.upper()}",
                    body=summary,
                    data={
                        "log_id": str(log_entry.id),
                        "status": status_val,
                        "host_id": str(host_id),
                    },
                )

        return {
            "success": True,
            "log_id": str(log_entry.id),
            "status": status_val,
            "summary": summary,
        }


register_tool(LogWellnessTool())
