from __future__ import annotations

import uuid
from unittest.mock import AsyncMock, MagicMock

import pytest
from fastapi import HTTPException

from src.lib.auth import CurrentUserInfo
from src.lib.authorization import authorize_host_access, authorize_relation_access
from src.relations.model import CareRelation

MOCK_HOST_ID = uuid.UUID("00000000-0000-4000-8000-000000000070")
MOCK_CAREGIVER_ID = uuid.UUID("00000000-0000-4000-8000-000000000071")
MOCK_OUTSIDER_ID = uuid.UUID("00000000-0000-4000-8000-000000000072")
MOCK_REL_ID = uuid.UUID("00000000-0000-4000-8000-000000000073")


def _user_info(user_id: uuid.UUID, role: str = "host") -> CurrentUserInfo:
    return CurrentUserInfo(id=str(user_id), role=role)


class TestAuthorizeHostAccess:
    """Tests for authorize_host_access."""

    @pytest.mark.asyncio
    async def test_self_access(self) -> None:
        """Host accessing own resources should succeed."""
        db = AsyncMock()
        user = _user_info(MOCK_HOST_ID)
        await authorize_host_access(db, user=user, host_id=MOCK_HOST_ID)
        db.execute.assert_not_called()

    @pytest.mark.asyncio
    async def test_caregiver_with_active_relation(self) -> None:
        """Caregiver with active CareRelation should succeed."""
        db = AsyncMock()
        mock_result = MagicMock()
        mock_result.scalar_one_or_none.return_value = MOCK_REL_ID
        db.execute.return_value = mock_result

        user = _user_info(MOCK_CAREGIVER_ID, role="concierge")
        await authorize_host_access(db, user=user, host_id=MOCK_HOST_ID)
        db.execute.assert_called_once()

    @pytest.mark.asyncio
    async def test_unauthorized_403(self) -> None:
        """User who is neither host nor caregiver should get 403."""
        db = AsyncMock()
        mock_result = MagicMock()
        mock_result.scalar_one_or_none.return_value = None
        db.execute.return_value = mock_result

        user = _user_info(MOCK_OUTSIDER_ID)
        with pytest.raises(HTTPException) as exc_info:
            await authorize_host_access(db, user=user, host_id=MOCK_HOST_ID)
        assert exc_info.value.status_code == 403


class TestAuthorizeRelationAccess:
    """Tests for authorize_relation_access."""

    @pytest.mark.asyncio
    async def test_as_host(self) -> None:
        """Host in the relation should succeed."""
        db = AsyncMock()
        relation = MagicMock(
            spec=CareRelation,
            host_id=MOCK_HOST_ID,
            caregiver_id=MOCK_CAREGIVER_ID,
        )
        user = _user_info(MOCK_HOST_ID)
        await authorize_relation_access(db, user=user, relation=relation)

    @pytest.mark.asyncio
    async def test_as_caregiver(self) -> None:
        """Caregiver in the relation should succeed."""
        db = AsyncMock()
        relation = MagicMock(
            spec=CareRelation,
            host_id=MOCK_HOST_ID,
            caregiver_id=MOCK_CAREGIVER_ID,
        )
        user = _user_info(MOCK_CAREGIVER_ID, role="concierge")
        await authorize_relation_access(db, user=user, relation=relation)

    @pytest.mark.asyncio
    async def test_outsider_403(self) -> None:
        """User not in the relation should get 403."""
        db = AsyncMock()
        relation = MagicMock(
            spec=CareRelation,
            host_id=MOCK_HOST_ID,
            caregiver_id=MOCK_CAREGIVER_ID,
        )
        user = _user_info(MOCK_OUTSIDER_ID)
        with pytest.raises(HTTPException) as exc_info:
            await authorize_relation_access(db, user=user, relation=relation)
        assert exc_info.value.status_code == 403
