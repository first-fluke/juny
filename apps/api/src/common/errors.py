"""Standardized error codes and helper for raising API errors."""

from typing import NoReturn

from fastapi import HTTPException

# Type alias for error tuples: (code, default_message)
type ErrorTuple = tuple[str, str]

# ── Auth ───────────────────────────────────────────────────────────
AUTH_001: ErrorTuple = ("AUTH_001", "Not authenticated")
AUTH_002: ErrorTuple = ("AUTH_002", "Invalid token")
AUTH_003: ErrorTuple = ("AUTH_003", "Invalid token type")

# ── Authorization ──────────────────────────────────────────────────
AUTHZ_001: ErrorTuple = ("AUTHZ_001", "Access denied")
AUTHZ_002: ErrorTuple = ("AUTHZ_002", "Insufficient role")

# ── Resources ──────────────────────────────────────────────────────
RES_001: ErrorTuple = ("RES_001", "Relation not found")
RES_002: ErrorTuple = ("RES_002", "Wellness log not found")
RES_003: ErrorTuple = ("RES_003", "Medication not found")
RES_004: ErrorTuple = ("RES_004", "User not found")
RES_005: ErrorTuple = ("RES_005", "Device token not found")

# ── Validation ─────────────────────────────────────────────────────
VAL_001: ErrorTuple = ("VAL_001", "Invalid caregiver role")
VAL_002: ErrorTuple = ("VAL_002", "Self-relation not allowed")

# ── Service ────────────────────────────────────────────────────────
SVC_001: ErrorTuple = ("SVC_001", "LiveKit is not configured")
SVC_002: ErrorTuple = ("SVC_002", "Gemini API is not configured")
SVC_003: ErrorTuple = ("SVC_003", "OAuth provider did not return an email address")
SVC_004: ErrorTuple = ("SVC_004", "Storage provider is not configured")
SVC_005: ErrorTuple = ("SVC_005", "File upload failed")


def raise_api_error(
    error: ErrorTuple,
    status_code: int,
    *,
    message: str | None = None,
    headers: dict[str, str] | None = None,
) -> NoReturn:
    """Raise an HTTPException with a structured error_code + message detail.

    Args:
        error: An ``(error_code, default_message)`` tuple from this module.
        status_code: HTTP status code.
        message: Optional override for the default message.
        headers: Optional response headers (e.g. WWW-Authenticate).
    """
    code, default_msg = error
    raise HTTPException(
        status_code=status_code,
        detail={"error_code": code, "message": message or default_msg},
        headers=headers,
    )
