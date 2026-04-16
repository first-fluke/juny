import 'package:flutter/material.dart';
import 'package:mobile/core/theme/generated_theme.dart';

/// {@template app_theme}
/// Senior-friendly theme with high contrast and large touch targets.
/// {@endtemplate}
class AppTheme {
  AppTheme._();

  // Semantic success color: oklch(0.65, 0.2, 145) — lime/green for medication.
  static const Color _successColor = Color(0xFF4CAF50);
  static const Color _onSuccessColor = Colors.white;

  // Semantic warning color: oklch(0.75, 0.18, 85) — amber for wellness.
  static const Color _warningColor = Color(0xFFFF9800);
  static const Color _onWarningColor = Colors.black;

  /// Tertiary color used for medication-related UI (semantic success/green).
  static const Color tertiary = _successColor;

  /// On-tertiary color used for text/icons on tertiary backgrounds.
  static const Color onTertiary = _onSuccessColor;

  /// Tertiary container color used for wellness-related UI (semantic warning/amber).
  static const Color tertiaryContainer = _warningColor;

  /// On-tertiary container color used for text/icons on tertiaryContainer backgrounds.
  static const Color onTertiaryContainer = _onWarningColor;

  /// The light theme optimized for senior accessibility.
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: generatedLightTheme.colors.primary,
      onPrimary: generatedLightTheme.colors.primaryForeground,
      secondary: generatedLightTheme.colors.secondary,
      onSecondary: generatedLightTheme.colors.secondaryForeground,
      tertiary: _successColor,
      onTertiary: _onSuccessColor,
      tertiaryContainer: _warningColor,
      onTertiaryContainer: _onWarningColor,
      error: generatedLightTheme.colors.error,
      onError: generatedLightTheme.colors.errorForeground,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headlineLarge: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      bodyLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      bodyMedium: TextStyle(fontSize: 20, color: Colors.black87),
      bodySmall: TextStyle(fontSize: 18, color: Colors.black54),
      labelLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 72),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 72),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, 72),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(minimumSize: const Size(56, 56)),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      contentTextStyle: TextStyle(fontSize: 18),
    ),
  );

  /// The dark theme.
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: generatedDarkTheme.colors.primary,
      onPrimary: generatedDarkTheme.colors.primaryForeground,
      secondary: generatedDarkTheme.colors.secondary,
      onSecondary: generatedDarkTheme.colors.secondaryForeground,
      tertiary: _successColor,
      onTertiary: _onSuccessColor,
      tertiaryContainer: _warningColor,
      onTertiaryContainer: _onWarningColor,
      error: generatedDarkTheme.colors.error,
      onError: generatedDarkTheme.colors.errorForeground,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(fontSize: 20),
      bodySmall: TextStyle(fontSize: 18),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 72),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
