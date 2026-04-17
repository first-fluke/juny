import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:mobile/core/config/app_config.dart';
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
    final liveKitUrl = AppConfig.liveKitUrl.trim();
    if (liveKitUrl.isEmpty) {
      setState(() => _isConnecting = false);
      _showMessage(
        'LIVEKIT_URL is not configured. Please set it via --dart-define.',
      );
      return;
    }

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
        liveKitUrl,
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
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      _showMessage(l10n?.errSvc001 ?? 'Failed to connect to live service.');
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    showFToast(
      context: context,
      title: Text(message),
    );
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

    return FScaffold(
      header: FHeader.nested(
        title: Text(l10n.liveSession),
        prefixes: [
          FHeaderAction.back(onPress: () => Navigator.of(context).pop()),
        ],
      ),
      child: SafeArea(
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
                                const FCircularProgress(),
                                const SizedBox(height: 24),
                                Text(l10n.connecting),
                              ],
                            )
                          : Text(l10n.disconnected),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: _isConnected
                  ? FButton(
                      variant: FButtonVariant.destructive,
                      onPress: _disconnect,
                      prefix: const Icon(Icons.call_end, size: 28),
                      child: Text(l10n.endLive),
                    )
                  : FButton(
                      onPress: _connectToRoom,
                      prefix: const Icon(Icons.videocam, size: 28),
                      child: Text(l10n.startLive),
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
      return const Center(child: FCircularProgress());
    }

    return VideoTrackRenderer(videoTrack);
  }
}
