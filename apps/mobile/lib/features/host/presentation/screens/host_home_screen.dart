import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
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
                color: const Color(0xFF0055FF),
                onPressed: () => context.go('/live/host'),
              ),
              const SizedBox(height: 20),
              _HomeButton(
                icon: Icons.medication,
                label: l10n.medications,
                color: const Color(0xFF4CAF50),
                onPressed: () => context.go('/medications'),
              ),
              const SizedBox(height: 20),
              _HomeButton(
                icon: Icons.favorite,
                label: l10n.wellness,
                color: const Color(0xFFFF7043),
                onPressed: () => context.go('/wellness'),
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
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 88),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
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
