"""Auth domain request/response schemas.

Re-exports the shared token types from lib.auth so that router.py
depends on the domain layer (auth.schemas) rather than the infra layer (lib.auth)
directly.
"""

from src.lib.auth import OAuthLoginRequest, RefreshTokenRequest, TokenResponse

__all__ = ["OAuthLoginRequest", "RefreshTokenRequest", "TokenResponse"]
