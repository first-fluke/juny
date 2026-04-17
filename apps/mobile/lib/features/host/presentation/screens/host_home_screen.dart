import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/i18n/generated/app_localizations.dart';

/// {@template host_home_screen}
/// Simplified home screen for senior (host) users.
/// Large buttons, minimal options, clear visual hierarchy.
/// {@endtemplate}
class HostHomeScreen extends ConsumerWidget {
  /// {@macro host_home_screen}
  const HostHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return FScaffold(
      header: FHeader(
        title: Text(l10n.appTitle),
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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text(
                l10n.welcomeHost,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              _HomeButton(
                icon: Icons.videocam,
                label: l10n.startLive,
                onPressed: () => context.go('/live/host'),
              ),
              const SizedBox(height: 20),
              _HomeButton(
                icon: Icons.medication,
                label: l10n.medications,
                onPressed: () => context.push('/medications'),
              ),
              const SizedBox(height: 20),
              _HomeButton(
                icon: Icons.favorite,
                label: l10n.wellness,
                onPressed: () => context.push('/wellness'),
              ),
              const SizedBox(height: 20),
              _HomeButton(
                icon: Icons.navigation,
                label: l10n.navigation,
                onPressed: () => context.push('/navigation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeButton extends StatelessWidget {
  const _HomeButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FButton(
      onPress: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36),
          const SizedBox(width: 16),
          Text(
            label,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
