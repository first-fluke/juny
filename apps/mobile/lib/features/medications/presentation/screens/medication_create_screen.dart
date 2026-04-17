import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
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
        showFToast(
          context: context,
          title: Text(l10n.error),
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

    return FScaffold(
      header: FHeader.nested(
        title: Text(l10n.addMedication),
        prefixes: [
          FHeaderAction.back(onPress: () => Navigator.of(context).pop()),
        ],
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            FTextFormField(
              control: FTextFieldControl.managed(
                controller: _pillNameController,
              ),
              label: Text(l10n.pillName),
              hint: l10n.pillName,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.fieldRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            FTile(
              prefix: const Icon(FIcons.clock),
              title: Text(l10n.scheduleTime),
              subtitle: Text(timeText),
              onPress: _pickTime,
            ),
            const SizedBox(height: 40),
            FButton(
              onPress: _isSubmitting ? null : _submit,
              prefix: _isSubmitting
                  ? const FCircularProgress()
                  : const Icon(FIcons.plus),
              child: Text(l10n.addMedication),
            ),
          ],
        ),
      ),
    );
  }
}
