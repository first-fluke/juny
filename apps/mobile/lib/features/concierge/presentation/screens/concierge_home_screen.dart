import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/concierge/data/concierge_repository.dart';
import 'package:mobile/features/concierge/presentation/providers/concierge_provider.dart';
import 'package:mobile/i18n/generated/app_localizations.dart';

/// {@template concierge_home_screen}
/// Dashboard for caregiver (concierge) users.
/// Shows care relations, medication status, and live session access.
/// {@endtemplate}
class ConciergeHomeScreen extends ConsumerWidget {
  /// {@macro concierge_home_screen}
  const ConciergeHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return FScaffold(
      header: FHeader(
        title: Text(l10n.welcomeConcierge),
        suffixes: [
          FHeaderAction(
            icon: Icon(
              Icons.notifications,
              size: 28,
              semanticLabel: l10n.notifications,
            ),
            onPress: () => context.push('/notifications'),
          ),
          FHeaderAction(
            icon: Icon(Icons.person, size: 28, semanticLabel: l10n.profile),
            onPress: () => context.push('/profile'),
          ),
          FHeaderAction(
            icon: Icon(Icons.logout, size: 28, semanticLabel: l10n.logout),
            onPress: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
      child: SafeArea(
        child: _ConciergeBody(),
      ),
    );
  }
}

/// Body widget that shows host summary cards plus navigation shortcuts.
class _ConciergeBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final summariesAsync = ref.watch<AsyncValue<List<HostSummary>>>(
      conciergeHostSummariesProvider,
    );

    final fallbackCards = <Widget>[
      _DashboardCard(
        icon: Icons.videocam,
        title: l10n.liveSession,
        onTap: () => context.push('/live/concierge'),
      ),
      _DashboardCard(
        icon: Icons.people,
        title: l10n.careRelations,
        onTap: () => context.push('/relations'),
      ),
    ];

    return summariesAsync.when(
      loading: () => const Center(child: FCircularProgress()),
      error: (_, _) => ListView(
        padding: const EdgeInsets.all(16),
        children: fallbackCards,
      ),
      data: (summaries) {
        final summaryWidgets = summaries
            .map<Widget>(
              (s) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _HostSummaryCard(summary: s),
              ),
            )
            .toList();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ...fallbackCards,
            if (summaries.isNotEmpty) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  l10n.careRelations,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              ...summaryWidgets,
            ],
          ],
        );
      },
    );
  }
}

/// Compact card showing aggregated host status for the concierge.
class _HostSummaryCard extends StatelessWidget {
  const _HostSummaryCard({required this.summary});

  final HostSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final wellness = summary.latestWellness;
    final pending = summary.pendingMedications ?? 0;
    final nav = summary.activeNavigation;

    return FCard.raw(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push(
          '/wellness?hostId=${summary.relation.hostId}',
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.person_outline, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      summary.relation.hostId,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  if (nav != null)
                    const Icon(Icons.navigation, size: 18, color: Colors.blue),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    wellness != null
                        ? (wellness.status == 'emergency'
                              ? Icons.warning
                              : Icons.check_circle)
                        : Icons.help_outline,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    wellness != null
                        ? Jiffy.parseFromDateTime(
                            wellness.createdAt,
                          ).fromNow()
                        : l10n.noWellnessLogs,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.medication, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '$pending ${l10n.medications}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FCard.raw(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    size: 28,
                    color: context.theme.colors.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: context.theme.colors.border,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
