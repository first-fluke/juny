import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';

/// {@template splash_screen}
/// Initial loading screen shown while restoring the auth session.
/// {@endtemplate}
class SplashScreen extends ConsumerStatefulWidget {
  /// {@macro splash_screen}
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(ref.read(authProvider.notifier).restoreSession());
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.health_and_safety,
              size: 80,
            ),
            const SizedBox(height: 24),
            Text(
              'Juny',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 32),
            const FCircularProgress(),
          ],
        ),
      ),
    );
  }
}
