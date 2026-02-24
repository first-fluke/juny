import 'package:mobile/core/network/api/export.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/medications/data/medications_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'medications_provider.g.dart';

@riverpod
MedicationsRepository medicationsRepository(Ref ref) {
  final apiClient = ref.watch(apiClientWrapperProvider);
  return MedicationsRepository(service: MedicationsService(apiClient.dio));
}

@riverpod
Future<PaginatedResponseMedicationResponse> medicationsList(
  Ref ref, {
  required String hostId,
  int page = 1,
}) {
  final repository = ref.watch(medicationsRepositoryProvider);
  return repository.list(hostId: hostId, page: page);
}
