import 'package:mobile/core/network/api/export.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/notifications/data/notification_logs_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_logs_provider.g.dart';

@riverpod
NotificationLogsRepository notificationLogsRepository(Ref ref) {
  final apiClient = ref.watch(apiClientWrapperProvider);
  return NotificationLogsRepository(
    notificationLogsService: NotificationLogsService(apiClient.dio),
  );
}

/// Provides a paginated page of notification logs.
///
/// [page] is 1-based. Re-watch with a different [page] value to fetch
/// subsequent pages.
@riverpod
Future<PaginatedResponseNotificationLogResponse> notificationLogs(
  Ref ref, {
  int page = 1,
  int limit = 20,
}) {
  final repository = ref.watch(notificationLogsRepositoryProvider);
  return repository.listLogs(page: page, limit: limit);
}
