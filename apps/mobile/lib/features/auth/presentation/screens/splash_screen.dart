import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// {@template splash_screen}
/// Initial loading screen shown while checking auth state.
/// {@endtemplate}
class SplashScreen extends ConsumerWidget {
  /// {@macro splash_screen}
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.health_and_safety, size: 80, color: Color(0xFF0055FF)),
            SizedBox(height: 24),
            Text(
              'Juny',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0055FF),
              ),
            ),
            SizedBox(height: 32),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
