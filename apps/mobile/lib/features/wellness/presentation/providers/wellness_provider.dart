import 'package:mobile/core/network/api/export.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/wellness/data/wellness_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wellness_provider.g.dart';

@riverpod
WellnessRepository wellnessRepository(Ref ref) {
  final apiClient = ref.watch(apiClientWrapperProvider);
  return WellnessRepository(service: WellnessService(apiClient.dio));
}

@riverpod
Future<PaginatedResponseWellnessLogResponse> wellnessLogsList(
  Ref ref, {
  required String hostId,
  int page = 1,
}) {
  final repository = ref.watch(wellnessRepositoryProvider);
  return repository.list(hostId: hostId, page: page);
}
