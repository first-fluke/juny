import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.welcomeConcierge),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, size: 28),
            tooltip: l10n.notifications,
            onPressed: () => context.push('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.person, size: 28),
            tooltip: l10n.profile,
            onPressed: () => context.push('/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.logout, size: 28),
            tooltip: l10n.logout,
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _DashboardCard(
              icon: Icons.videocam,
              iconColor: const Color(0xFF0055FF),
              title: l10n.liveSession,
              onTap: () => context.push('/live/concierge'),
              trailing: FilledButton.icon(
                onPressed: () => context.push('/live/concierge'),
                icon: const Icon(Icons.visibility, size: 24),
                label: Text(l10n.watchLive),
              ),
            ),
            _DashboardCard(
              icon: Icons.people,
              iconColor: const Color(0xFF7B1FA2),
              title: l10n.careRelations,
              onTap: () => context.push('/relations'),
            ),
            _DashboardCard(
              icon: Icons.medication,
              iconColor: const Color(0xFF4CAF50),
              title: l10n.medications,
              onTap: () => context.push('/medications'),
            ),
            _DashboardCard(
              icon: Icons.favorite,
              iconColor: const Color(0xFFFF7043),
              title: l10n.wellness,
              onTap: () => context.push('/wellness'),
            ),
            _DashboardCard(
              icon: Icons.navigation,
              iconColor: const Color(0xFF1565C0),
              title: l10n.navigation,
              onTap: () => context.push('/navigation'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  Icon(icon, size: 28, color: iconColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ],
              ),
              if (trailing != null) ...[
                const SizedBox(height: 16),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
