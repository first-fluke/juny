import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:livekit_client/livekit_client.dart' as lk;
import 'package:mobile/core/config/app_config.dart';
import 'package:mobile/core/network/api/export.dart';
import 'package:mobile/features/live/presentation/providers/live_provider.dart';
import 'package:mobile/i18n/generated/app_localizations.dart';

/// Maximum number of automatic reconnect attempts.
const _kMaxRetries = 5;

/// Initial backoff delay in seconds (doubles each attempt: 2→4→8→16→32).
const _kBaseBackoffSeconds = 2;

/// {@template host_live_screen}
/// Live video session screen for the senior (host).
/// Publishes local camera and microphone tracks.
///
/// Reconnects automatically on disconnect with exponential backoff
/// (max [_kMaxRetries] attempts, starting at [_kBaseBackoffSeconds] s).
/// {@endtemplate}
class HostLiveScreen extends ConsumerStatefulWidget {
  /// {@macro host_live_screen}
  const HostLiveScreen({super.key});

  @override
  ConsumerState<HostLiveScreen> createState() => _HostLiveScreenState();
}

class _HostLiveScreenState extends ConsumerState<HostLiveScreen> {
  lk.Room? _room;
  lk.LocalParticipant? _localParticipant;
  bool _isConnected = false;
  bool _isConnecting = false;

  int _retryCount = 0;
  Timer? _retryTimer;
  bool _userDisconnected = false;

  @override
  void initState() {
    super.initState();
    unawaited(_connectToRoom());
  }

  Future<void> _connectToRoom({bool isRetry = false}) async {
    if (!mounted) return;
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

      await _room?.dispose();

      _room = lk.Room(
        roomOptions: const lk.RoomOptions(
          adaptiveStream: true,
          dynacast: true,
          defaultCameraCaptureOptions: lk.CameraCaptureOptions(
            maxFrameRate: 30,
          ),
        ),
      );

      _room!.addListener(_onRoomEvent);

      await _room!.connect(liveKitUrl, tokenResponse.token);

      await _room!.localParticipant?.setCameraEnabled(true);
      await _room!.localParticipant?.setMicrophoneEnabled(true);

      if (!mounted) return;
      setState(() {
        _localParticipant = _room!.localParticipant;
        _isConnected = true;
        _isConnecting = false;
        _retryCount = 0;
      });
    } on Exception {
      if (!mounted) return;
      setState(() {
        _isConnected = false;
        _isConnecting = false;
      });
      if (!isRetry) {
        final l10n = AppLocalizations.of(context);
        _showMessage(l10n?.errSvc001 ?? 'Failed to connect to live service.');
      }
      _scheduleRetry();
    }
  }

  /// Called when the LiveKit room emits a state-change event.
  void _onRoomEvent() {
    if (_userDisconnected) return;
    final roomState = _room?.connectionState;
    if (roomState == lk.ConnectionState.disconnected && mounted) {
      setState(() {
        _isConnected = false;
        _localParticipant = null;
      });
      _scheduleRetry();
    }
  }

  /// Schedules the next retry with exponential backoff.
  void _scheduleRetry() {
    if (_userDisconnected) return;
    if (_retryCount >= _kMaxRetries) return;

    _retryTimer?.cancel();
    final delay = Duration(
      seconds: _kBaseBackoffSeconds * math.pow(2, _retryCount).toInt(),
    );
    _retryCount++;
    _retryTimer = Timer(delay, () => unawaited(_connectToRoom(isRetry: true)));
  }

  void _showMessage(String message) {
    if (!mounted) return;
    showFToast(context: context, title: Text(message));
  }

  Future<void> _disconnect() async {
    _userDisconnected = true;
    _retryTimer?.cancel();
    await _room?.disconnect();
    if (!mounted) return;
    setState(() {
      _isConnected = false;
      _localParticipant = null;
    });
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _userDisconnected = true;
    _retryTimer?.cancel();
    _room?.removeListener(_onRoomEvent);
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
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(l10n.disconnected),
                                if (_retryCount > 0 &&
                                    _retryCount < _kMaxRetries) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    '재연결 시도 $_retryCount / $_kMaxRetries',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ],
                            ),
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
                      onPress: _isConnecting
                          ? null
                          : () {
                              _userDisconnected = false;
                              _retryCount = 0;
                              unawaited(_connectToRoom());
                            },
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
        .map((pub) => pub.track! as lk.VideoTrack)
        .firstOrNull;

    if (videoTrack == null) {
      return const Center(child: FCircularProgress());
    }

    return lk.VideoTrackRenderer(videoTrack);
  }
}
