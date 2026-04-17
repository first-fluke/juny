import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mobile/core/network/api/export.dart';
import 'package:mobile/features/medications/presentation/providers/medications_provider.dart';
import 'package:mobile/i18n/generated/app_localizations.dart';

/// {@template medications_screen}
/// Displays medication list with mark-as-taken functionality.
/// {@endtemplate}
class MedicationsScreen extends ConsumerWidget {
  /// {@macro medications_screen}
  const MedicationsScreen({required this.hostId, super.key});

  /// The host ID to display medications for.
  final String hostId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final medicationsAsync = ref.watch(
      medicationsListProvider(hostId: hostId),
    );

    return FScaffold(
      header: FHeader.nested(
        title: Text(l10n.medications),
        prefixes: [
          FHeaderAction.back(onPress: () => Navigator.of(context).pop()),
        ],
      ),
      childPad: false,
      child: Stack(
        children: [
          medicationsAsync.when(
            loading: () => const Center(child: FCircularProgress()),
            error: (error, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.error,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  FButton(
                    onPress: () => ref.invalidate(
                      medicationsListProvider(hostId: hostId),
                    ),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            ),
            data: (response) {
              final items = response.data;
              if (items.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      l10n.noMedications,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (context, index) => Dismissible(
                  key: ValueKey(items[index].id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Theme.of(context).colorScheme.error,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => _deleteMedication(ref, items[index].id),
                  child: _MedicationCard(
                    medication: items[index],
                    onMarkTaken: () => _markAsTaken(ref, items[index].id),
                  ),
                ),
              );
            },
          ),
          Positioned(
            right: 16,
            bottom: 24,
            child: FButton.icon(
              onPress: () => context.push('/medications/create?hostId=$hostId'),
              child: Icon(FIcons.plus, semanticLabel: l10n.addMedication),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _markAsTaken(WidgetRef ref, String medicationId) async {
    final repository = ref.read(medicationsRepositoryProvider);
    await repository.markAsTaken(medicationId);
    ref.invalidate(medicationsListProvider(hostId: hostId));
  }

  Future<void> _deleteMedication(WidgetRef ref, String medicationId) async {
    final repository = ref.read(medicationsRepositoryProvider);
    await repository.delete(medicationId);
    ref.invalidate(medicationsListProvider(hostId: hostId));
  }
}

class _MedicationCard extends StatelessWidget {
  const _MedicationCard({
    required this.medication,
    required this.onMarkTaken,
  });

  final MedicationResponse medication;
  final VoidCallback onMarkTaken;

  @override
  Widget build(BuildContext context) {
    final scheduleTime = Jiffy.parseFromDateTime(
      medication.scheduleTime,
    ).format(pattern: 'HH:mm');

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: FCard.raw(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(
                medication.isTaken ? Icons.check_circle : Icons.circle_outlined,
                size: 40,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medication.pillName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      scheduleTime,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              if (!medication.isTaken)
                FButton(
                  onPress: onMarkTaken,
                  mainAxisSize: MainAxisSize.min,
                  child: const Icon(Icons.check, size: 28),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
