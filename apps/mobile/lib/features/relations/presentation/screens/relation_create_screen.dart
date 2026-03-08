import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/relations/presentation/providers/relations_provider.dart';
import 'package:mobile/i18n/generated/app_localizations.dart';

/// {@template relation_create_screen}
/// Form screen for creating a new care relation.
/// {@endtemplate}
class RelationCreateScreen extends ConsumerStatefulWidget {
  /// {@macro relation_create_screen}
  const RelationCreateScreen({super.key});

  @override
  ConsumerState<RelationCreateScreen> createState() =>
      _RelationCreateScreenState();
}

class _RelationCreateScreenState extends ConsumerState<RelationCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _hostIdController = TextEditingController();
  final _caregiverIdController = TextEditingController();
  String _selectedRole = 'CONCIERGE';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _hostIdController.dispose();
    _caregiverIdController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      final repository = ref.read(relationsRepositoryProvider);
      await repository.create(
        hostId: _hostIdController.text.trim(),
        caregiverId: _caregiverIdController.text.trim(),
        role: _selectedRole,
      );

      if (mounted) {
        ref.invalidate(relationsListProvider());
        context.pop();
      }
    } on Exception {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.error)),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.addRelation)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            TextFormField(
              controller: _hostIdController,
              decoration: InputDecoration(
                labelText: l10n.hostId,
                prefixIcon: const Icon(Icons.person),
                border: const OutlineInputBorder(),
              ),
              style: Theme.of(context).textTheme.bodyMedium,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.fieldRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _caregiverIdController,
              decoration: const InputDecoration(
                labelText: 'Caregiver ID',
                prefixIcon: Icon(Icons.people),
                border: OutlineInputBorder(),
              ),
              style: Theme.of(context).textTheme.bodyMedium,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.fieldRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Text(
              l10n.caregiverRole,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(
                  value: 'CONCIERGE',
                  label: Text(l10n.roleConcierge),
                  icon: const Icon(Icons.shield),
                ),
                ButtonSegment(
                  value: 'CARE_WORKER',
                  label: Text(l10n.roleCareWorker),
                  icon: const Icon(Icons.medical_services),
                ),
              ],
              selected: {_selectedRole},
              onSelectionChanged: (selected) {
                setState(() => _selectedRole = selected.first);
              },
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all(const Size(0, 56)),
              ),
            ),
            const SizedBox(height: 40),
            FilledButton.icon(
              onPressed: _isSubmitting ? null : _submit,
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.add),
              label: Text(l10n.addRelation),
            ),
          ],
        ),
      ),
    );
  }
}
