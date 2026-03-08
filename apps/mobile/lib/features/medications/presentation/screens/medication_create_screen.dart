import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/medications/presentation/providers/medications_provider.dart';
import 'package:mobile/i18n/generated/app_localizations.dart';

/// {@template medication_create_screen}
/// Form screen for adding a new medication schedule.
/// {@endtemplate}
class MedicationCreateScreen extends ConsumerStatefulWidget {
  /// {@macro medication_create_screen}
  const MedicationCreateScreen({required this.hostId, super.key});

  /// The host ID to create the medication for.
  final String hostId;

  @override
  ConsumerState<MedicationCreateScreen> createState() =>
      _MedicationCreateScreenState();
}

class _MedicationCreateScreenState
    extends ConsumerState<MedicationCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pillNameController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _pillNameController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && mounted) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      final now = DateTime.now();
      final scheduleTime = DateTime(
        now.year,
        now.month,
        now.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final repository = ref.read(medicationsRepositoryProvider);
      await repository.create(
        hostId: widget.hostId,
        pillName: _pillNameController.text.trim(),
        scheduleTime: scheduleTime,
      );

      if (mounted) {
        ref.invalidate(medicationsListProvider(hostId: widget.hostId));
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
    final timeText = _selectedTime.format(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.addMedication)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            TextFormField(
              controller: _pillNameController,
              decoration: InputDecoration(
                labelText: l10n.pillName,
                prefixIcon: const Icon(Icons.medication),
                border: const OutlineInputBorder(),
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
            ListTile(
              leading: const Icon(Icons.access_time, size: 28),
              title: Text(l10n.scheduleTime),
              subtitle: Text(
                timeText,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Theme.of(context).colorScheme.outline),
              ),
              onTap: _pickTime,
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
              label: Text(l10n.addMedication),
            ),
          ],
        ),
      ),
    );
  }
}
