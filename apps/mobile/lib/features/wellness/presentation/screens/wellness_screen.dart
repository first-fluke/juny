import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    return Scaffold(
      appBar: AppBar(title: Text(l10n.wellness)),
      body: logsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.error, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.invalidate(
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

    final (icon, color) = switch (log.status) {
      'emergency' => (Icons.warning, const Color(0xFFD32F2F)),
      'warning' => (Icons.info, const Color(0xFFFF9800)),
      _ => (Icons.check_circle, const Color(0xFF4CAF50)),
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 36, color: color),
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
    );
  }
}
