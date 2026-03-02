"""Internal API key authentication for service-to-service calls."""

from fastapi import Depends, Request, status

from src.common.errors import AUTH_001, raise_api_error
from src.lib.config import settings
from src.lib.logging import get_logger

logger = get_logger(__name__)


async def verify_internal_key(request: Request) -> None:
    """Verify X-Internal-Key header matches configured secret."""
    if not settings.INTERNAL_API_KEY:
        if settings.PROJECT_ENV == "prod":
            raise_api_error(AUTH_001, status.HTTP_401_UNAUTHORIZED)
        logger.warning("internal_auth_skip_mock", env=settings.PROJECT_ENV)
        return
    key = request.headers.get("X-Internal-Key", "")
    if key != settings.INTERNAL_API_KEY:
        raise_api_error(AUTH_001, status.HTTP_401_UNAUTHORIZED)


InternalAuth = Depends(verify_internal_key)
