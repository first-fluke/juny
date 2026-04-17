import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
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

    return FScaffold(
      header: FHeader.nested(
        title: Text(l10n.notificationSettings),
        prefixes: [
          FHeaderAction.back(onPress: () => Navigator.of(context).pop()),
        ],
      ),
      childPad: false,
      child: prefsAsync.when(
        loading: () => const Center(child: FCircularProgress()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.error, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 16),
              FButton(
                onPress: () =>
                    ref.invalidate(notificationPreferencesProvider),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
        data: (prefs) => ListView(
          children: [
            FTile(
              prefix: const Icon(Icons.favorite),
              title: Text(l10n.wellnessAlerts),
              suffix: FSwitch(
                value: prefs.wellnessAlerts,
                onChange: (value) => _updatePreference(
                  ref,
                  wellnessAlerts: value,
                ),
              ),
            ),
            FTile(
              prefix: const Icon(Icons.medication),
              title: Text(l10n.medicationReminders),
              suffix: FSwitch(
                value: prefs.medicationReminders,
                onChange: (value) => _updatePreference(
                  ref,
                  medicationReminders: value,
                ),
              ),
            ),
            FTile(
              prefix: const Icon(Icons.system_update),
              title: Text(l10n.systemUpdates),
              suffix: FSwitch(
                value: prefs.systemUpdates,
                onChange: (value) => _updatePreference(
                  ref,
                  systemUpdates: value,
                ),
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
