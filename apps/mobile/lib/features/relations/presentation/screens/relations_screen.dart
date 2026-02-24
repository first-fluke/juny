import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mobile/core/network/api/export.dart';
import 'package:mobile/features/relations/presentation/providers/relations_provider.dart';
import 'package:mobile/i18n/generated/app_localizations.dart';

/// {@template relations_screen}
/// Displays care relations for the current user.
/// {@endtemplate}
class RelationsScreen extends ConsumerWidget {
  /// {@macro relations_screen}
  const RelationsScreen({this.hostId, this.caregiverId, super.key});

  /// Filter by host ID.
  final String? hostId;

  /// Filter by caregiver ID.
  final String? caregiverId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final relationsAsync = ref.watch(
      relationsListProvider(hostId: hostId, caregiverId: caregiverId),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Care Relations'),
      ),
      body: relationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.error, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.invalidate(
                  relationsListProvider(
                    hostId: hostId,
                    caregiverId: caregiverId,
                  ),
                ),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
        data: (relations) {
          if (relations.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'No care relations found.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: relations.length,
            itemBuilder: (context, index) => _RelationCard(
              relation: relations[index],
              onDeactivate: () => _deactivate(ref, relations[index].id),
            ),
          );
        },
      ),
    );
  }

  Future<void> _deactivate(WidgetRef ref, String relationId) async {
    final repository = ref.read(relationsRepositoryProvider);
    await repository.deactivate(relationId);
    ref.invalidate(
      relationsListProvider(hostId: hostId, caregiverId: caregiverId),
    );
  }
}

class _RelationCard extends StatelessWidget {
  const _RelationCard({
    required this.relation,
    required this.onDeactivate,
  });

  final CareRelationResponse relation;
  final VoidCallback onDeactivate;

  @override
  Widget build(BuildContext context) {
    final date = Jiffy.parseFromDateTime(
      relation.createdAt,
    ).format(pattern: 'yyyy-MM-dd');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              relation.isActive ? Icons.people : Icons.people_outline,
              size: 36,
              color: relation.isActive
                  ? const Color(0xFF0055FF)
                  : const Color(0xFFBDBDBD),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    relation.role,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (relation.isActive)
              IconButton(
                onPressed: onDeactivate,
                icon: const Icon(Icons.link_off, size: 28),
                tooltip: 'Deactivate',
                style: IconButton.styleFrom(
                  foregroundColor: const Color(0xFFD32F2F),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
