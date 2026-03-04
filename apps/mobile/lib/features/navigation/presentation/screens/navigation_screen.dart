import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/navigation/presentation/providers/navigation_provider.dart';
import 'package:mobile/i18n/generated/app_localizations.dart';

/// {@template navigation_screen}
/// Displays the active navigation session for a host.
/// {@endtemplate}
class NavigationScreen extends ConsumerWidget {
  /// {@macro navigation_screen}
  const NavigationScreen({required this.hostId, super.key});

  /// The host ID to display navigation for.
  final String hostId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final sessionAsync = ref.watch(
      activeNavigationSessionProvider(hostId: hostId),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navigation)),
      body: sessionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.error, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.invalidate(
                  activeNavigationSessionProvider(hostId: hostId),
                ),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
        data: (session) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.navigation,
                          size: 36,
                          color: Color(0xFF1565C0),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            session.destinationName,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      session.status,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => _cancelSession(ref, session.id),
                      icon: const Icon(Icons.close),
                      label: Text(l10n.cancel),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFD32F2F),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _cancelSession(WidgetRef ref, String sessionId) async {
    final repository = ref.read(navigationRepositoryProvider);
    await repository.cancelSession(sessionId);
    ref.invalidate(activeNavigationSessionProvider(hostId: hostId));
  }
}
