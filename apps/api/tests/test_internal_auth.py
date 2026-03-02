"""Tests for internal API key authentication."""

from __future__ import annotations

from unittest.mock import MagicMock, patch

import pytest
from fastapi import HTTPException

from src.lib.internal_auth import verify_internal_key


class TestVerifyInternalKey:
    @pytest.mark.asyncio
    @patch("src.lib.internal_auth.settings")
    async def test_prod_no_key_returns_401(self, mock_settings: MagicMock) -> None:
        """Prod environment without INTERNAL_API_KEY must fail-secure."""
        mock_settings.INTERNAL_API_KEY = ""
        mock_settings.PROJECT_ENV = "prod"
        request = MagicMock()
        with pytest.raises(HTTPException) as exc_info:
            await verify_internal_key(request)
        assert exc_info.value.status_code == 401

    @pytest.mark.asyncio
    @patch("src.lib.internal_auth.settings")
    async def test_local_no_key_skips(self, mock_settings: MagicMock) -> None:
        """Local/staging without key should skip (no error)."""
        mock_settings.INTERNAL_API_KEY = ""
        mock_settings.PROJECT_ENV = "local"
        request = MagicMock()
        await verify_internal_key(request)  # Should not raise

    @pytest.mark.asyncio
    @patch("src.lib.internal_auth.settings")
    async def test_valid_key_passes(self, mock_settings: MagicMock) -> None:
        mock_settings.INTERNAL_API_KEY = "secret-key"
        mock_settings.PROJECT_ENV = "prod"
        request = MagicMock()
        request.headers.get.return_value = "secret-key"
        await verify_internal_key(request)  # Should not raise

    @pytest.mark.asyncio
    @patch("src.lib.internal_auth.settings")
    async def test_invalid_key_returns_401(self, mock_settings: MagicMock) -> None:
        mock_settings.INTERNAL_API_KEY = "secret-key"
        mock_settings.PROJECT_ENV = "prod"
        request = MagicMock()
        request.headers.get.return_value = "wrong-key"
        with pytest.raises(HTTPException) as exc_info:
            await verify_internal_key(request)
        assert exc_info.value.status_code == 401
