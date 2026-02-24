import 'package:mobile/core/network/api/export.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/relations/data/relations_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'relations_provider.g.dart';

@riverpod
RelationsRepository relationsRepository(Ref ref) {
  final apiClient = ref.watch(apiClientWrapperProvider);
  return RelationsRepository(service: RelationsService(apiClient.dio));
}

@riverpod
Future<List<CareRelationResponse>> relationsList(
  Ref ref, {
  String? hostId,
  String? caregiverId,
}) {
  final repository = ref.watch(relationsRepositoryProvider);
  return repository.list(hostId: hostId, caregiverId: caregiverId);
}
