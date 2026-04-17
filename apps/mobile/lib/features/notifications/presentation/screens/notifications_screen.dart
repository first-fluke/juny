import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mobile/core/network/api/export.dart';
import 'package:mobile/features/notifications/presentation/providers/notification_logs_provider.dart';
import 'package:mobile/i18n/generated/app_localizations.dart';

/// {@template notifications_screen}
/// Chronological list of notification logs with read/unread state.
///
/// Tapping an unread item marks it as read via the PATCH status endpoint.
/// A settings icon in the AppBar navigates to the notification settings screen.
/// {@endtemplate}
class NotificationsScreen extends ConsumerWidget {
  /// {@macro notifications_screen}
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final logsAsync = ref.watch(notificationLogsProvider());

    return FScaffold(
      header: FHeader(
        title: Text(l10n.notifications),
        suffixes: [
          FHeaderAction(
            icon: Icon(
              FIcons.settings,
              semanticLabel: l10n.notificationSettings,
            ),
            onPress: () => context.push('/notifications/settings'),
          ),
        ],
      ),
      childPad: false,
      child: logsAsync.when(
        loading: () => const Center(child: FCircularProgress()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.error, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 16),
              FButton(
                onPress: () => ref.invalidate(notificationLogsProvider()),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
        data: (response) {
          final items = response.data;
          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  l10n.noNotifications,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: items.length,
            separatorBuilder: (_, _) => const FDivider(),
            itemBuilder: (context, index) => _NotificationTile(
              log: items[index],
              onTap: () => _markAsRead(ref, items[index]),
            ),
          );
        },
      ),
    );
  }

  Future<void> _markAsRead(WidgetRef ref, NotificationLogResponse log) async {
    if (log.status == 'read') return;
    final repository = ref.read(notificationLogsRepositoryProvider);
    await repository.markAsRead(log.id);
    ref.invalidate(notificationLogsProvider());
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.log,
    required this.onTap,
  });

  final NotificationLogResponse log;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isUnread = log.status != 'read';
    final timeLabel = Jiffy.parseFromDateTime(log.createdAt).fromNow();
    final colors = context.theme.colors;

    return InkWell(
      onTap: onTap,
      child: ColoredBox(
        color: isUnread
            ? colors.muted.withValues(alpha: 0.15)
            : Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Icon(
                  isUnread ? Icons.notifications : Icons.notifications_outlined,
                  size: 24,
                  color: isUnread ? colors.primary : colors.mutedForeground,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      log.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: isUnread
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      log.body,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.mutedForeground,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timeLabel,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colors.border,
                      ),
                    ),
                  ],
                ),
              ),
              if (isUnread)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 8),
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
