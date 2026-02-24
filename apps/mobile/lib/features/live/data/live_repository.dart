import 'package:mobile/core/network/api/export.dart';

/// {@template live_repository}
/// Manages LiveKit room connections and token acquisition.
/// {@endtemplate}
class LiveRepository {
  /// {@macro live_repository}
  LiveRepository({required LiveService liveService})
    : _liveService = liveService;

  final LiveService _liveService;

  /// Fetch a LiveKit token for joining a room.
  Future<LiveTokenResponse> getToken({
    required String roomName,
    required Role role,
  }) async {
    return _liveService.getLiveTokenApiV1LiveTokenGet(
      roomName: roomName,
      role: role,
    );
  }
}
