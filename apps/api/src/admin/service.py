"""Admin business logic."""

from datetime import UTC, datetime, timedelta
from typing import Any
from uuid import UUID

from sqlalchemy.ext.asyncio import AsyncSession

from src.admin import repository
from src.admin.model import AuditLog
from src.admin.schemas import (
    CleanupResponse,
    InactiveRelationResponse,
    WellnessAggregateResponse,
)
from src.medications import repository as medication_repo
from src.notifications import repository as notification_repo
from src.relations import repository as relation_repo
from src.users import repository as user_repo
from src.wellness import repository as wellness_repo


async def _log_audit(
    db: AsyncSession,
    *,
    action: str,
    resource_type: str,
    detail: dict[str, object] | None = None,
    description: str | None = None,
) -> None:
    """Create an audit log entry."""
    entry = AuditLog(
        action=action,
        resource_type=resource_type,
        detail=detail or {},
        description=description,
    )
    await repository.create_audit_log(db, entry)


async def cleanup_data(
    db: AsyncSession, retention_days: int, resource_type: str
) -> CleanupResponse:
    """Orchestrate data cleanup based on retention policy."""
    before = datetime.now(UTC) - timedelta(days=retention_days)

    deleted_logs = 0
    deactivated = 0

    if resource_type in ("all", "wellness_logs"):
        deleted_logs = await repository.delete_old_wellness_logs(db, before)

    if resource_type in ("all", "device_tokens"):
        deactivated = await repository.deactivate_old_tokens(db, before)

    await _log_audit(
        db,
        action="cleanup",
        resource_type=resource_type,
        detail={
            "retention_days": retention_days,
            "deleted_wellness_logs": deleted_logs,
            "deactivated_tokens": deactivated,
        },
    )
    await db.commit()
    return CleanupResponse(
        deleted_wellness_logs=deleted_logs,
        deactivated_tokens=deactivated,
    )


async def get_inactive_relations(
    db: AsyncSession, threshold_days: int
) -> list[InactiveRelationResponse]:
    """Fetch inactive relations and convert to DTOs."""
    rows = await repository.find_inactive_relations(db, threshold_days)
    return [
        InactiveRelationResponse(
            relation_id=row.relation_id,
            host_id=row.host_id,
            caregiver_id=row.caregiver_id,
            role=row.role,
            last_wellness_at=row.last_wellness_at,
            inactive_days=int(row.inactive_days),
        )
        for row in rows
    ]


async def deactivate_failed_tokens(db: AsyncSession, tokens: list[str]) -> int:
    """Deactivate failed FCM tokens. Returns count of deactivated tokens."""
    if not tokens:
        return 0
    count = await notification_repo.deactivate_tokens(db, tokens)
    await _log_audit(
        db,
        action="deactivate_tokens",
        resource_type="device_tokens",
        detail={"token_count": len(tokens), "deactivated": count},
    )
    await db.commit()
    return count


async def list_audit_logs(
    db: AsyncSession,
    *,
    limit: int = 50,
    offset: int = 0,
) -> tuple[list[AuditLog], int]:
    """List audit log entries (newest first) with pagination."""
    return await repository.find_audit_logs(db, limit=limit, offset=offset)


async def get_wellness_aggregate(
    db: AsyncSession, host_id: UUID, date: str
) -> WellnessAggregateResponse:
    """Compute daily wellness statistics for a host."""
    by_status = await repository.aggregate_wellness(db, host_id, date)
    total = sum(by_status.values())
    return WellnessAggregateResponse(
        host_id=host_id,
        date=date,
        total_logs=total,
        by_status=by_status,
    )


async def export_user_data(db: AsyncSession, user_id: UUID) -> dict[str, Any]:
    """Collect all data for a user across every domain (GDPR export).

    Returns a dict with keys: user, relations, wellness_logs,
    medications, device_tokens.
    """
    user = await user_repo.find_by_id(db, user_id)
    if user is None:
        return {}

    relations, _ = await relation_repo.find_by_host(
        db, user_id, active_only=False, limit=10000, offset=0
    )
    caregiver_relations, _ = await relation_repo.find_by_caregiver(
        db, user_id, active_only=False, limit=10000, offset=0
    )
    wellness_logs, _ = await wellness_repo.find_by_host(
        db, user_id, limit=10000, offset=0
    )
    medications, _ = await medication_repo.find_by_host(
        db, user_id, limit=10000, offset=0
    )
    device_tokens = await notification_repo.find_by_user(db, user_id, active_only=False)

    def _serialize(obj: Any) -> dict[str, Any]:
        if hasattr(obj, "__dict__"):
            return {k: str(v) for k, v in obj.__dict__.items() if not k.startswith("_")}
        return {}

    return {
        "user": _serialize(user),
        "relations_as_host": [_serialize(r) for r in relations],
        "relations_as_caregiver": [_serialize(r) for r in caregiver_relations],
        "wellness_logs": [_serialize(w) for w in wellness_logs],
        "medications": [_serialize(m) for m in medications],
        "device_tokens": [_serialize(dt) for dt in device_tokens],
    }
