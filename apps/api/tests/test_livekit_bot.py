"""Tests for DuckingBotParticipant."""

from __future__ import annotations

import json
from typing import Any
from unittest.mock import AsyncMock, MagicMock, patch

import pytest

from src.lib.livekit.bot import DuckingBotParticipant

MOCK_ROOM = "room-123"
MOCK_HOST = "host-001"


@pytest.fixture
def bot() -> DuckingBotParticipant:
    return DuckingBotParticipant(room_name=MOCK_ROOM, host_identity=MOCK_HOST)


def _data_packet(topic: str, payload: Any) -> MagicMock:
    """Create a fake data_packet with topic and data attributes."""
    pkt = MagicMock()
    pkt.topic = topic
    if isinstance(payload, (dict, list)):
        pkt.data = json.dumps(payload).encode()
    elif isinstance(payload, bytes):
        pkt.data = payload
    else:
        pkt.data = str(payload).encode()
    return pkt


class TestDuckingBotConnect:
    @pytest.mark.asyncio
    @patch("src.lib.livekit.bot.create_live_token", return_value="fake-token")
    @patch("src.lib.livekit.bot.rtc")
    @patch("src.lib.livekit.bot.settings")
    async def test_connect_creates_room_and_joins(
        self,
        mock_settings: MagicMock,
        mock_rtc: MagicMock,
        mock_token: MagicMock,
        bot: DuckingBotParticipant,
    ) -> None:
        mock_settings.LIVEKIT_API_URL = "wss://livekit.example.com"
        mock_room = AsyncMock()
        mock_room.on = MagicMock()  # on() is sync
        mock_rtc.Room.return_value = mock_room

        await bot.connect()

        mock_rtc.Room.assert_called_once()
        mock_room.connect.assert_called_once_with(
            "wss://livekit.example.com", "fake-token"
        )

    @pytest.mark.asyncio
    @patch("src.lib.livekit.bot.create_live_token", return_value="fake-token")
    @patch("src.lib.livekit.bot.rtc")
    @patch("src.lib.livekit.bot.settings")
    async def test_connect_no_url_returns_early(
        self,
        mock_settings: MagicMock,
        mock_rtc: MagicMock,
        mock_token: MagicMock,
        bot: DuckingBotParticipant,
    ) -> None:
        mock_settings.LIVEKIT_API_URL = None

        await bot.connect()

        mock_rtc.Room.assert_not_called()
        assert bot._room is None


class TestDuckingBotDataReceived:
    def test_ducking_active_sets_event(self, bot: DuckingBotParticipant) -> None:
        pkt = _data_packet("ducking", {"active": True})
        bot._on_data_received(pkt)
        assert bot.ducking_active.is_set() is True

    def test_ducking_inactive_clears_event(self, bot: DuckingBotParticipant) -> None:
        bot.ducking_active.set()
        pkt = _data_packet("ducking", {"active": False})
        bot._on_data_received(pkt)
        assert bot.ducking_active.is_set() is False

    def test_invalid_json_ignored(self, bot: DuckingBotParticipant) -> None:
        pkt = _data_packet("ducking", b"not-json{{{")
        bot._on_data_received(pkt)
        # No exception raised, ducking unchanged
        assert bot.ducking_active.is_set() is False

    def test_wrong_topic_ignored(self, bot: DuckingBotParticipant) -> None:
        bot.ducking_active.set()
        pkt = _data_packet("other", {"active": False})
        bot._on_data_received(pkt)
        # Ducking state unchanged
        assert bot.ducking_active.is_set() is True


class TestDuckingBotDisconnect:
    @pytest.mark.asyncio
    async def test_disconnect_calls_room_disconnect(
        self, bot: DuckingBotParticipant
    ) -> None:
        mock_room = AsyncMock()
        bot._room = mock_room

        await bot.disconnect()

        mock_room.disconnect.assert_called_once()
        assert bot._room is None

    @pytest.mark.asyncio
    async def test_disconnect_noop_when_no_room(
        self, bot: DuckingBotParticipant
    ) -> None:
        assert bot._room is None
        await bot.disconnect()
        assert bot._room is None
