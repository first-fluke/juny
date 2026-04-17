import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
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

    return FScaffold(
      header: FHeader.nested(
        title: Text(l10n.careRelations),
        prefixes: [
          FHeaderAction.back(onPress: () => Navigator.of(context).pop()),
        ],
      ),
      childPad: false,
      child: Stack(
        children: [
          relationsAsync.when(
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
                      l10n.noRelations,
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
          Positioned(
            right: 16,
            bottom: 24,
            child: FButton.icon(
              onPress: () => context.push('/relations/create'),
              child: Icon(FIcons.userPlus, semanticLabel: l10n.addRelation),
            ),
          ),
        ],
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
    final l10n = AppLocalizations.of(context)!;
    final date = Jiffy.parseFromDateTime(
      relation.createdAt,
    ).format(pattern: 'yyyy-MM-dd');

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: FCard.raw(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(
                relation.isActive ? Icons.people : Icons.people_outline,
                size: 36,
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
                FButton.icon(
                  onPress: onDeactivate,
                  child: Icon(
                    FIcons.unlink,
                    semanticLabel: l10n.deactivateRelation,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
