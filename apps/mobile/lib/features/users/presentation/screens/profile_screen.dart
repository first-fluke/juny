import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
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

    return FScaffold(
      header: FHeader.nested(
        title: Text(l10n.profile),
        prefixes: [
          FHeaderAction.back(onPress: () => Navigator.of(context).pop()),
        ],
      ),
      childPad: false,
      child: userAsync.when(
        loading: () => const Center(child: FCircularProgress()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.error, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 16),
              FButton(
                onPress: () => ref.invalidate(currentUserProvider),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
        data: (user) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            FCard.raw(
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
            FCard.raw(
              child: Column(
                children: [
                  FTile(
                    prefix: const Icon(Icons.download),
                    title: Text(l10n.exportData),
                    onPress: () => _exportData(ref),
                  ),
                  const FDivider(),
                  FTile(
                    variant: FItemVariant.destructive,
                    prefix: const Icon(Icons.delete_forever),
                    title: Text(l10n.deleteAccount),
                    onPress: () => _confirmDelete(context, ref),
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
    final confirmed = await showFDialog<bool>(
      context: context,
      builder: (context, style, animation) => FDialog(
        animation: animation,
        title: Text(l10n.deleteAccount),
        body: Text(l10n.confirm),
        actions: [
          FButton(
            onPress: () => Navigator.of(context).pop(true),
            child: Text(l10n.delete),
          ),
          FButton(
            variant: FButtonVariant.ghost,
            onPress: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
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
