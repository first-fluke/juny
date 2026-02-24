from datetime import timedelta
from typing import Literal

import structlog
from livekit.api import AccessToken, VideoGrants
from pydantic import BaseModel

from src.lib.config import settings

logger = structlog.get_logger(__name__)

LiveRole = Literal["host", "concierge", "organization", "ai-bridge"]

_ROLE_SOURCES: dict[LiveRole, list[str]] = {
    "host": ["camera", "microphone"],
    "concierge": ["microphone"],
    "organization": ["microphone"],
    "ai-bridge": [],
}


class LiveTokenResponse(BaseModel):
    token: str
    room_name: str
    identity: str
    role: LiveRole


def create_live_token(
    room_name: str,
    role: LiveRole,
    identity: str,
    ttl: timedelta = timedelta(hours=6),
) -> str:
    """Create a LiveKit access token with role-based grants.

    Host: can publish camera + microphone, can subscribe.
    Concierge: can publish microphone only, can subscribe.
    """
    api_key = settings.LIVEKIT_API_KEY
    api_secret = settings.LIVEKIT_API_SECRET

    if not api_key or not api_secret:
        raise ValueError("LIVEKIT_API_KEY and LIVEKIT_API_SECRET must be configured")

    if role == "ai-bridge":
        grants = VideoGrants(
            room_join=True,
            room=room_name,
            can_publish=False,
            can_publish_data=True,
            can_subscribe=True,
        )
    else:
        grants = VideoGrants(
            room_join=True,
            room=room_name,
            can_publish=True,
            can_subscribe=True,
            can_publish_sources=_ROLE_SOURCES[role],
        )

    token = (
        AccessToken(api_key=api_key, api_secret=api_secret)
        .with_identity(identity)
        .with_ttl(ttl)
        .with_grants(grants)
        .to_jwt()
    )

    logger.info(
        "livekit_token_created",
        room_name=room_name,
        role=role,
        identity=identity,
    )
    return token
