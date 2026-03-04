import 'package:mobile/core/network/api/export.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/notifications/data/notifications_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications_provider.g.dart';

@riverpod
NotificationsRepository notificationsRepository(Ref ref) {
  final apiClient = ref.watch(apiClientWrapperProvider);
  return NotificationsRepository(
    notificationsService: NotificationsService(apiClient.dio),
    notificationLogsService: NotificationLogsService(apiClient.dio),
  );
}

@riverpod
Future<NotificationPreferenceResponse> notificationPreferences(Ref ref) {
  final repository = ref.watch(notificationsRepositoryProvider);
  return repository.getPreferences();
}

@riverpod
Future<PaginatedResponseNotificationLogResponse> notificationLogsList(
  Ref ref, {
  int page = 1,
}) {
  final repository = ref.watch(notificationsRepositoryProvider);
  return repository.listLogs(page: page);
}
