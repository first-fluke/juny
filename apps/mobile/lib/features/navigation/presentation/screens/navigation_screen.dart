import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:mobile/features/navigation/presentation/providers/navigation_provider.dart';
import 'package:mobile/i18n/generated/app_localizations.dart';

/// {@template navigation_screen}
/// Displays the active navigation session for a host,
/// or a start navigation form when no session is active.
/// {@endtemplate}
class NavigationScreen extends ConsumerWidget {
  /// {@macro navigation_screen}
  const NavigationScreen({required this.hostId, super.key});

  /// The host ID to display navigation for.
  final String hostId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final sessionAsync = ref.watch(
      activeNavigationSessionProvider(hostId: hostId),
    );

    return FScaffold(
      header: FHeader.nested(
        title: Text(l10n.navigation),
        prefixes: [
          FHeaderAction.back(onPress: () => Navigator.of(context).pop()),
        ],
      ),
      child: sessionAsync.when(
        loading: () => const Center(child: FCircularProgress()),
        error: (error, _) => _StartNavigationForm(hostId: hostId),
        data: (session) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: FCard.raw(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.navigation,
                          size: 36,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(session.destinationName),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(session.status),
                    const SizedBox(height: 16),
                    FButton(
                      variant: FButtonVariant.destructive,
                      onPress: () => _cancelSession(ref, session.id),
                      prefix: const Icon(Icons.close),
                      child: Text(l10n.cancel),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _cancelSession(WidgetRef ref, String sessionId) async {
    final repository = ref.read(navigationRepositoryProvider);
    await repository.cancelSession(sessionId);
    ref.invalidate(activeNavigationSessionProvider(hostId: hostId));
  }
}

class _StartNavigationForm extends ConsumerStatefulWidget {
  const _StartNavigationForm({required this.hostId});

  final String hostId;

  @override
  ConsumerState<_StartNavigationForm> createState() =>
      _StartNavigationFormState();
}

class _StartNavigationFormState extends ConsumerState<_StartNavigationForm> {
  final _destinationController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  Future<void> _startNavigation() async {
    final destination = _destinationController.text.trim();
    if (destination.isEmpty) return;

    setState(() => _isSubmitting = true);
    try {
      final repository = ref.read(navigationRepositoryProvider);
      await repository.startSession(
        hostId: widget.hostId,
        destinationQuery: destination,
        originLat: 0,
        originLng: 0,
      );

      if (mounted) {
        ref.invalidate(
          activeNavigationSessionProvider(hostId: widget.hostId),
        );
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

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 40),
        const Icon(
          Icons.navigation_outlined,
          size: 80,
        ),
        const SizedBox(height: 16),
        Text(
          l10n.noActiveNavigation,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        FTextFormField(
          control: FTextFieldControl.managed(
            controller: _destinationController,
          ),
          label: Text(l10n.destination),
          hint: l10n.destination,
          textInputAction: TextInputAction.done,
          onSubmit: (_) => _startNavigation(),
        ),
        const SizedBox(height: 24),
        FButton(
          onPress: _isSubmitting ? null : _startNavigation,
          prefix: _isSubmitting
              ? const FCircularProgress()
              : const Icon(Icons.navigation),
          child: Text(l10n.startNavigation),
        ),
      ],
    );
  }
}
