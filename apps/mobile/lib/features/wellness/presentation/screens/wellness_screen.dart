import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mobile/core/network/api/export.dart';
import 'package:mobile/features/wellness/presentation/providers/wellness_provider.dart';
import 'package:mobile/i18n/generated/app_localizations.dart';

/// {@template wellness_screen}
/// Displays wellness log history and 30-day trends for a host.
///
/// Two tabs: Logs (existing list) and Trends (bar chart from API).
/// {@endtemplate}
class WellnessScreen extends ConsumerStatefulWidget {
  /// {@macro wellness_screen}
  const WellnessScreen({required this.hostId, super.key});

  /// The host ID to display wellness logs for.
  final String hostId;

  @override
  ConsumerState<WellnessScreen> createState() => _WellnessScreenState();
}

class _WellnessScreenState extends ConsumerState<WellnessScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FScaffold(
      header: FHeader.nested(
        title: Text(l10n.wellness),
        prefixes: [
          FHeaderAction.back(onPress: () => Navigator.of(context).pop()),
        ],
      ),
      childPad: false,
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: l10n.wellness),
              const Tab(text: 'Trends'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _LogsTab(hostId: widget.hostId),
                _TrendsTab(hostId: widget.hostId),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LogsTab extends ConsumerWidget {
  const _LogsTab({required this.hostId});

  final String hostId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final logsAsync = ref.watch(wellnessLogsListProvider(hostId: hostId));

    return Stack(
      children: [
        logsAsync.when(
          loading: () => const Center(child: FCircularProgress()),
          error: (_, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(l10n.error, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 16),
                FButton(
                  onPress: () =>
                      ref.invalidate(wellnessLogsListProvider(hostId: hostId)),
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
              itemBuilder: (context, index) =>
                  _WellnessLogCard(log: items[index]),
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
    );
  }
}

class _TrendsTab extends ConsumerWidget {
  const _TrendsTab({required this.hostId});

  final String hostId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final trendsAsync = ref.watch(wellnessTrendsProvider(hostId: hostId));

    return trendsAsync.when(
      loading: () => const Center(child: FCircularProgress()),
      error: (_, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.error, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            FButton(
              onPress: () =>
                  ref.invalidate(wellnessTrendsProvider(hostId: hostId)),
              child: Text(l10n.retry),
            ),
          ],
        ),
      ),
      data: (trends) {
        final stats = trends.dailyStats;
        if (stats.isEmpty) {
          return Center(
            child: Text(
              l10n.noWellnessLogs,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }
        final statWidgets = stats
            .map<Widget>(
              (s) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: FCard.raw(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 80,
                          child: Text(
                            s.date,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _StatusBar(
                          normal: s.normal,
                          warning: s.warning,
                          emergency: s.emergency,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList();
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              '${trends.dateFrom} ~ ${trends.dateTo}',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ...statWidgets,
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Legend(color: Colors.green, label: 'Normal'),
                SizedBox(width: 12),
                _Legend(color: Colors.orange, label: 'Warning'),
                SizedBox(width: 12),
                _Legend(color: Colors.red, label: 'Emergency'),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar({
    required this.normal,
    required this.warning,
    required this.emergency,
  });

  final int normal;
  final int warning;
  final int emergency;

  @override
  Widget build(BuildContext context) {
    final total = (normal + warning + emergency).toDouble();
    if (total == 0) {
      return const Expanded(
        child: ColoredBox(
          color: Colors.transparent,
          child: SizedBox(height: 16),
        ),
      );
    }

    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Row(
          children: [
            if (normal > 0)
              Flexible(
                flex: normal,
                child: const ColoredBox(
                  color: Colors.green,
                  child: SizedBox(height: 16),
                ),
              ),
            if (warning > 0)
              Flexible(
                flex: warning,
                child: const ColoredBox(
                  color: Colors.orange,
                  child: SizedBox(height: 16),
                ),
              ),
            if (emergency > 0)
              Flexible(
                flex: emergency,
                child: const ColoredBox(
                  color: Colors.red,
                  child: SizedBox(height: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
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
