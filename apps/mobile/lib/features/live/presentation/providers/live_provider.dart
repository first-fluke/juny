import 'package:mobile/core/network/api/export.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/live/data/live_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'live_provider.g.dart';

@riverpod
LiveRepository liveRepository(Ref ref) {
  final apiClient = ref.watch(apiClientWrapperProvider);
  return LiveRepository(liveService: LiveService(apiClient.dio));
}

@riverpod
Future<LiveTokenResponse> liveToken(
  Ref ref, {
  required String roomName,
  required Role role,
}) {
  final repository = ref.watch(liveRepositoryProvider);
  return repository.getToken(roomName: roomName, role: role);
}
