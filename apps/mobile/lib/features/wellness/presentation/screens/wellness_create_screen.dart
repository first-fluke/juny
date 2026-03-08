import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/network/api/export.dart';
import 'package:mobile/features/wellness/presentation/providers/wellness_provider.dart';
import 'package:mobile/i18n/generated/app_localizations.dart';

/// {@template wellness_create_screen}
/// Form screen for adding a new wellness log entry.
/// {@endtemplate}
class WellnessCreateScreen extends ConsumerStatefulWidget {
  /// {@macro wellness_create_screen}
  const WellnessCreateScreen({required this.hostId, super.key});

  /// The host ID to create the wellness log for.
  final String hostId;

  @override
  ConsumerState<WellnessCreateScreen> createState() =>
      _WellnessCreateScreenState();
}

class _WellnessCreateScreenState extends ConsumerState<WellnessCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _summaryController = TextEditingController();
  WellnessStatus _selectedStatus = WellnessStatus.normal;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _summaryController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      final repository = ref.read(wellnessRepositoryProvider);
      await repository.create(
        hostId: widget.hostId,
        status: _selectedStatus,
        summary: _summaryController.text.trim(),
      );

      if (mounted) {
        ref.invalidate(wellnessLogsListProvider(hostId: widget.hostId));
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
      appBar: AppBar(title: Text(l10n.addWellnessLog)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              l10n.statusNormal,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            SegmentedButton<WellnessStatus>(
              segments: [
                ButtonSegment(
                  value: WellnessStatus.normal,
                  label: Text(l10n.statusNormal),
                  icon: const Icon(Icons.check_circle),
                ),
                ButtonSegment(
                  value: WellnessStatus.warning,
                  label: Text(l10n.statusWarning),
                  icon: const Icon(Icons.info),
                ),
                ButtonSegment(
                  value: WellnessStatus.emergency,
                  label: Text(l10n.statusEmergency),
                  icon: const Icon(Icons.warning),
                ),
              ],
              selected: {_selectedStatus},
              onSelectionChanged: (selected) {
                setState(() => _selectedStatus = selected.first);
              },
              style: ButtonStyle(
                visualDensity: VisualDensity.comfortable,
                minimumSize: WidgetStateProperty.all(const Size(0, 56)),
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _summaryController,
              decoration: InputDecoration(
                labelText: l10n.wellnessSummary,
                prefixIcon: const Icon(Icons.notes),
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 4,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.fieldRequired;
                }
                return null;
              },
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
              label: Text(l10n.addWellnessLog),
            ),
          ],
        ),
      ),
    );
  }
}
