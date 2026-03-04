import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/notifications/presentation/providers/notifications_provider.dart';
import 'package:mobile/i18n/generated/app_localizations.dart';

/// {@template notification_settings_screen}
/// Manages notification preferences for the current user.
/// {@endtemplate}
class NotificationSettingsScreen extends ConsumerWidget {
  /// {@macro notification_settings_screen}
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final prefsAsync = ref.watch(notificationPreferencesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.notificationSettings)),
      body: prefsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.error, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () =>
                    ref.invalidate(notificationPreferencesProvider),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
        data: (prefs) => ListView(
          children: [
            SwitchListTile(
              title: Text(l10n.wellnessAlerts),
              secondary: const Icon(Icons.favorite),
              value: prefs.wellnessAlerts,
              onChanged: (value) => _updatePreference(
                ref,
                wellnessAlerts: value,
              ),
            ),
            SwitchListTile(
              title: Text(l10n.medicationReminders),
              secondary: const Icon(Icons.medication),
              value: prefs.medicationReminders,
              onChanged: (value) => _updatePreference(
                ref,
                medicationReminders: value,
              ),
            ),
            SwitchListTile(
              title: Text(l10n.systemUpdates),
              secondary: const Icon(Icons.system_update),
              value: prefs.systemUpdates,
              onChanged: (value) => _updatePreference(
                ref,
                systemUpdates: value,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updatePreference(
    WidgetRef ref, {
    bool? wellnessAlerts,
    bool? medicationReminders,
    bool? systemUpdates,
  }) async {
    final repository = ref.read(notificationsRepositoryProvider);
    await repository.updatePreferences(
      wellnessAlerts: wellnessAlerts,
      medicationReminders: medicationReminders,
      systemUpdates: systemUpdates,
    );
    ref.invalidate(notificationPreferencesProvider);
  }
}
