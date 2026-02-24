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
            icon: const Icon(Icons.logout, size: 28),
            tooltip: l10n.logout,
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.videocam,
                            size: 28,
                            color: Color(0xFF0055FF),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            l10n.liveSession,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () => context.go('/live/concierge'),
                        icon: const Icon(Icons.visibility, size: 24),
                        label: Text(l10n.watchLive),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.medication,
                            size: 28,
                            color: Color(0xFF4CAF50),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            l10n.medications,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.noMedications,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.favorite,
                            size: 28,
                            color: Color(0xFFFF7043),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            l10n.wellness,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.noWellnessLogs,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
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
