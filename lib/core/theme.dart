import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF034A3C); // Dark Teal
  static const Color secondaryColor = Color(0xFFEDEECE);
  static const Color accentColor = Color(0xFFEDEECE);
  static const Color highlightColor = Color(0xFFEDEECE);
  static const Color backgroundColor = Color(0xFFF8FAFC); // Tailwind slate-50
  static const Color textPrimary = Color(0xFF034A3C);
  static const Color textSecondary = Color(0xFF4B5563);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      fontFamily: 'Metropolis',
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        error: Colors.redAccent,
        surface: backgroundColor,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Metropolis',
          color: textPrimary,
          fontWeight: FontWeight.w800,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Metropolis',
          color: textPrimary,
          fontWeight: FontWeight.w700,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Metropolis',
          color: textPrimary,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Metropolis',
          color: textPrimary,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Metropolis',
          color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(fontFamily: 'Metropolis', color: textPrimary),
        bodyMedium: TextStyle(fontFamily: 'Metropolis', color: textSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: highlightColor,
          foregroundColor: primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    const Color darkBackground = Color(0xFF121212);
    const Color darkSurface = Color(0xFF1E1E1E);
    const Color darkTextPrimary = Color(0xFFE0E0E0);
    const Color darkTextSecondary = Color(0xFFA0A0A0);

    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      fontFamily: 'Metropolis',
      scaffoldBackgroundColor: darkBackground,
      primaryColor: highlightColor,
      colorScheme: const ColorScheme.dark(
        primary: highlightColor,
        secondary: accentColor,
        error: Colors.redAccent,
        surface: darkSurface,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Metropolis',
          color: darkTextPrimary,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Metropolis',
          color: darkTextPrimary,
          fontWeight: FontWeight.w700,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Metropolis',
          color: darkTextPrimary,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Metropolis',
          color: darkTextPrimary,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Metropolis',
          color: darkTextPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(fontFamily: 'Metropolis', color: darkTextPrimary),
        bodyMedium:
            TextStyle(fontFamily: 'Metropolis', color: darkTextSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: highlightColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: highlightColor,
          side: const BorderSide(color: highlightColor, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
    );
  }
}
