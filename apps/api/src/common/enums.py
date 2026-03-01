import enum


class UserRole(str, enum.Enum):
    """4-Tier RBAC roles for B2B/B2G expansion."""

    HOST = "host"
    CONCIERGE = "concierge"
    CARE_WORKER = "care_worker"
    ORGANIZATION = "organization"


class WellnessStatus(str, enum.Enum):
    """Wellness log severity levels."""

    NORMAL = "normal"
    WARNING = "warning"
    EMERGENCY = "emergency"


class NavigationStatus(str, enum.Enum):
    """Navigation session lifecycle states."""

    ACTIVE = "active"
    COMPLETED = "completed"
    CANCELLED = "cancelled"
