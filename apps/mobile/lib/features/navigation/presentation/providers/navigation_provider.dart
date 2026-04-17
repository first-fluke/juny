import 'package:mobile/core/network/api/export.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/navigation/data/location_tracking_service.dart';
import 'package:mobile/features/navigation/data/navigation_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navigation_provider.g.dart';

@riverpod
NavigationRepository navigationRepository(Ref ref) {
  final apiClient = ref.watch(apiClientWrapperProvider);
  return NavigationRepository(service: NavigationService(apiClient.dio));
}

@riverpod
Future<NavigationSessionResponse> activeNavigationSession(
  Ref ref, {
  required String hostId,
}) {
  final repository = ref.watch(navigationRepositoryProvider);
  return repository.getActiveSession(hostId: hostId);
}

@riverpod
Future<LocationWaypointResponse?> hostLocation(
  Ref ref, {
  required String hostId,
}) {
  final repository = ref.watch(navigationRepositoryProvider);
  return repository.getHostLocation(hostId);
}

/// Manages the lifecycle of [LocationTrackingService] for an active session.
///
/// Automatically stops tracking and flushes remaining waypoints on dispose.
@riverpod
LocationTrackingService locationTracking(
  Ref ref, {
  required String hostId,
  required String sessionId,
}) {
  final repository = ref.watch(navigationRepositoryProvider);
  final service = LocationTrackingService(
    repository: repository,
    hostId: hostId,
    sessionId: sessionId,
  );
  ref.onDispose(service.stop);
  return service;
}
