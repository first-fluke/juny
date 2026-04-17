import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mobile/core/network/api/export.dart';
import 'package:mobile/features/wellness/presentation/providers/wellness_provider.dart';
import 'package:mobile/i18n/generated/app_localizations.dart';

/// {@template wellness_screen}
/// Displays wellness log history for a host.
/// {@endtemplate}
class WellnessScreen extends ConsumerWidget {
  /// {@macro wellness_screen}
  const WellnessScreen({required this.hostId, super.key});

  /// The host ID to display wellness logs for.
  final String hostId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final logsAsync = ref.watch(wellnessLogsListProvider(hostId: hostId));

    return FScaffold(
      header: FHeader.nested(
        title: Text(l10n.wellness),
        prefixes: [
          FHeaderAction.back(onPress: () => Navigator.of(context).pop()),
        ],
      ),
      childPad: false,
      child: Stack(
        children: [
          logsAsync.when(
            loading: () => const Center(child: FCircularProgress()),
            error: (error, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.error,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  FButton(
                    onPress: () => ref.invalidate(
                      wellnessLogsListProvider(hostId: hostId),
                    ),
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
                      l10n.noWellnessLogs,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (context, index) => _WellnessLogCard(
                  log: items[index],
                ),
              );
            },
          ),
          Positioned(
            right: 16,
            bottom: 24,
            child: FButton.icon(
              onPress: () => context.push('/wellness/create?hostId=$hostId'),
              child: Icon(FIcons.plus, semanticLabel: l10n.addWellnessLog),
            ),
          ),
        ],
      ),
    );
  }
}

class _WellnessLogCard extends StatelessWidget {
  const _WellnessLogCard({required this.log});

  final WellnessLogResponse log;

  @override
  Widget build(BuildContext context) {
    final date = Jiffy.parseFromDateTime(
      log.createdAt,
    ).format(pattern: 'yyyy-MM-dd HH:mm');

    final icon = switch (log.status) {
      'emergency' => Icons.warning,
      'warning' => Icons.info,
      _ => Icons.check_circle,
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: FCard.raw(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 36),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      log.summary,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      date,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
