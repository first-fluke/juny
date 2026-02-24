import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:mobile/core/network/api/export.dart';
import 'package:mobile/features/live/presentation/providers/live_provider.dart';
import 'package:mobile/i18n/generated/app_localizations.dart';

/// {@template concierge_live_screen}
/// Live session screen for the caregiver (concierge).
/// Subscribes to the host's video track and supports audio ducking.
/// {@endtemplate}
class ConciergeLiveScreen extends ConsumerStatefulWidget {
  /// {@macro concierge_live_screen}
  const ConciergeLiveScreen({super.key});

  @override
  ConsumerState<ConciergeLiveScreen> createState() =>
      _ConciergeLiveScreenState();
}

class _ConciergeLiveScreenState extends ConsumerState<ConciergeLiveScreen> {
  Room? _room;
  bool _isConnected = false;
  bool _isConnecting = false;
  bool _isDucking = false;
  RemoteParticipant? _hostParticipant;

  @override
  void initState() {
    super.initState();
    unawaited(_connectToRoom());
  }

  Future<void> _connectToRoom() async {
    setState(() => _isConnecting = true);

    try {
      final tokenResponse = await ref.read(
        liveTokenProvider(
          roomName: 'host-room',
          role: Role.concierge,
        ).future,
      );

      _room = Room(
        roomOptions: const RoomOptions(
          adaptiveStream: true,
          dynacast: true,
        ),
      );

      _room!.addListener(_onRoomEvent);

      await _room!.connect(
        // TODO(live): configure LiveKit URL from environment
        'wss://livekit.example.com',
        tokenResponse.token,
      );

      setState(() {
        _isConnected = true;
        _isConnecting = false;
      });

      _findHostParticipant();
    } on Exception {
      setState(() => _isConnecting = false);
    }
  }

  void _onRoomEvent() {
    _findHostParticipant();
    setState(() {});
  }

  void _findHostParticipant() {
    final participants = _room?.remoteParticipants.values ?? [];
    for (final participant in participants) {
      if (participant.identity.startsWith('host:')) {
        _hostParticipant = participant;
        return;
      }
    }
  }

  /// Toggle audio ducking via Data Channel.
  Future<void> _toggleDucking() async {
    final newState = !_isDucking;
    final payload = jsonEncode({
      'type': 'ducking',
      'active': newState,
    });

    await _room?.localParticipant?.publishData(
      utf8.encode(payload),
      reliable: true,
    );

    setState(() => _isDucking = newState);

    if (newState) {
      await _room?.localParticipant?.setMicrophoneEnabled(true);
    } else {
      await _room?.localParticipant?.setMicrophoneEnabled(false);
    }
  }

  Future<void> _disconnect() async {
    await _room?.disconnect();
    setState(() {
      _isConnected = false;
      _hostParticipant = null;
    });
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _room?.removeListener(_onRoomEvent);
    unawaited(_room?.disconnect());
    unawaited(_room?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.liveSession)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _isConnected
                  ? _buildRemoteVideo()
                  : Center(
                      child: _isConnecting
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(),
                                const SizedBox(height: 24),
                                Text(
                                  l10n.connecting,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            )
                          : Text(
                              l10n.disconnected,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                    ),
            ),
            if (_isConnected)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _toggleDucking,
                        icon: Icon(
                          _isDucking ? Icons.mic : Icons.mic_off,
                          size: 28,
                        ),
                        label: Text(l10n.speakToSenior),
                        style: FilledButton.styleFrom(
                          backgroundColor: _isDucking
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFF757575),
                          minimumSize: const Size(0, 72),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    FilledButton.icon(
                      onPressed: _disconnect,
                      icon: const Icon(Icons.call_end, size: 28),
                      label: Text(l10n.endLive),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size(120, 72),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildRemoteVideo() {
    if (_hostParticipant == null) {
      return Center(
        child: Text(
          'Waiting for senior to connect...',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    final videoTrack = _hostParticipant!.videoTrackPublications
        .where((pub) => pub.track != null && !pub.muted)
        .map((pub) => pub.track! as VideoTrack)
        .firstOrNull;

    if (videoTrack == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.videocam_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Camera is off',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      );
    }

    return VideoTrackRenderer(videoTrack);
  }
}
