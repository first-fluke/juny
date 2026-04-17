import 'package:mobile/core/network/api/export.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/concierge/data/concierge_repository.dart';
import 'package:mobile/features/users/presentation/providers/users_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'concierge_provider.g.dart';

@riverpod
ConciergeRepository conciergeRepository(Ref ref) {
  final apiClient = ref.watch(apiClientWrapperProvider);
  return ConciergeRepository(
    relationsService: RelationsService(apiClient.dio),
    wellnessService: WellnessService(apiClient.dio),
    medicationsService: MedicationsService(apiClient.dio),
    navigationService: NavigationService(apiClient.dio),
  );
}

/// Returns aggregated host summaries for the authenticated concierge user.
///
/// Resolves the current user ID first, then fetches all active relations
/// where the current user is the caregiver and aggregates per-host data.
@riverpod
Future<List<HostSummary>> conciergeHostSummaries(Ref ref) async {
  final user = await ref.watch(currentUserProvider.future);
  final repository = ref.read(conciergeRepositoryProvider);
  return repository.listHostSummaries(caregiverId: user.id);
}
