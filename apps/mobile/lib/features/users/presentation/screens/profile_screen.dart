import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/users/presentation/providers/users_provider.dart';
import 'package:mobile/i18n/generated/app_localizations.dart';

/// {@template profile_screen}
/// Displays and manages the current user's profile.
/// {@endtemplate}
class ProfileScreen extends ConsumerWidget {
  /// {@macro profile_screen}
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile)),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.error, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.invalidate(currentUserProvider),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
        data: (user) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundImage:
                          user.image != null ? NetworkImage(user.image!) : null,
                      child:
                          user.image == null
                              ? const Icon(Icons.person, size: 48)
                              : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.name ?? user.email,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.download),
                    title: Text(l10n.exportData),
                    onTap: () => _exportData(ref),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.delete_forever,
                      color: Color(0xFFD32F2F),
                    ),
                    title: Text(
                      l10n.deleteAccount,
                      style: const TextStyle(color: Color(0xFFD32F2F)),
                    ),
                    onTap: () => _confirmDelete(context, ref),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportData(WidgetRef ref) async {
    final repository = ref.read(usersRepositoryProvider);
    await repository.exportMyData();
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAccount),
        content: Text(l10n.confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final repository = ref.read(usersRepositoryProvider);
      await repository.deleteMe();
      await ref.read(authProvider.notifier).logout();
    }
  }
}
