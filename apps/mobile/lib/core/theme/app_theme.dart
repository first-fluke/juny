import 'package:flutter/material.dart';

/// {@template app_theme}
/// Senior-friendly theme with high contrast and large touch targets.
/// {@endtemplate}
class AppTheme {
  AppTheme._();

  static const _primaryColor = Color(0xFF0055FF);
  static const _errorColor = Color(0xFFD32F2F);

  /// The light theme optimized for senior accessibility.
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: _primaryColor,
      secondary: Color(0xFF4CAF50),
      onSecondary: Colors.white,
      error: _errorColor,
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
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: Brightness.dark,
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
