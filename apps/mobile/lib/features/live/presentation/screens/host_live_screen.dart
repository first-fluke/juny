import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:mobile/core/network/api/export.dart';
import 'package:mobile/features/live/presentation/providers/live_provider.dart';
import 'package:mobile/i18n/generated/app_localizations.dart';

/// {@template host_live_screen}
/// Live video session screen for the senior (host).
/// Publishes local camera and microphone tracks.
/// {@endtemplate}
class HostLiveScreen extends ConsumerStatefulWidget {
  /// {@macro host_live_screen}
  const HostLiveScreen({super.key});

  @override
  ConsumerState<HostLiveScreen> createState() => _HostLiveScreenState();
}

class _HostLiveScreenState extends ConsumerState<HostLiveScreen> {
  Room? _room;
  LocalParticipant? _localParticipant;
  bool _isConnected = false;
  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();
    unawaited(_connectToRoom());
  }

  Future<void> _connectToRoom() async {
    setState(() => _isConnecting = true);

    try {
      final tokenResponse = await ref.read(
        liveTokenProvider(roomName: 'host-room', role: Role.host).future,
      );

      _room = Room(
        roomOptions: const RoomOptions(
          adaptiveStream: true,
          dynacast: true,
          defaultCameraCaptureOptions: CameraCaptureOptions(
            maxFrameRate: 30,
          ),
        ),
      );

      await _room!.connect(
        // TODO(live): configure LiveKit URL from environment
        'wss://livekit.example.com',
        tokenResponse.token,
      );

      await _room!.localParticipant?.setCameraEnabled(true);
      await _room!.localParticipant?.setMicrophoneEnabled(true);

      setState(() {
        _localParticipant = _room!.localParticipant;
        _isConnected = true;
        _isConnecting = false;
      });
    } on Exception {
      setState(() => _isConnecting = false);
    }
  }

  Future<void> _disconnect() async {
    await _room?.disconnect();
    setState(() {
      _isConnected = false;
      _localParticipant = null;
    });
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
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
              child: _isConnected && _localParticipant != null
                  ? _buildLocalVideo()
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
            Padding(
              padding: const EdgeInsets.all(24),
              child: FilledButton.icon(
                onPressed: _isConnected ? _disconnect : _connectToRoom,
                icon: Icon(
                  _isConnected ? Icons.call_end : Icons.videocam,
                  size: 28,
                ),
                label: Text(
                  _isConnected ? l10n.endLive : l10n.startLive,
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: _isConnected
                      ? Colors.red
                      : const Color(0xFF0055FF),
                  minimumSize: const Size(double.infinity, 72),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocalVideo() {
    final videoTrack = _localParticipant?.videoTrackPublications
        .where((pub) => pub.track != null)
        .map((pub) => pub.track! as VideoTrack)
        .firstOrNull;

    if (videoTrack == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return VideoTrackRenderer(videoTrack);
  }
}
