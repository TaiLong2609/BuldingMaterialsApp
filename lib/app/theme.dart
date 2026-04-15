import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Architectural Blueprint Colors
  static const Color primary = Color(0xFF005DAC);
  static const Color primaryContainer = Color(0xFF1976D2);
  static const Color onPrimary = Colors.white;
  static const Color onPrimaryFixedVariant = Color(0xFF004786);
  static const Color primaryFixed = Color(0xFFD4E3FF);
  static const Color onPrimaryFixed = Color(0xFF001C3A);

  static const Color secondary = Color(0xFF875200);
  static const Color secondaryContainer = Color(0xFFF89C00);
  static const Color onSecondaryContainer = Color(0xFF623A00);

  static const Color background = Color(0xFFF8F9FB);
  static const Color surface = Color(0xFFF8F9FB);
  static const Color surfaceContainerLow = Color(0xFFF2F4F6);
  static const Color surfaceContainerHighest = Color(0xFFE2E2E2);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceBright = Color(0xFFF8F9FB);
  
  static const Color onSurface = Color(0xFF191C1E);
  static const Color onSurfaceVariant = Color(0xFF414752);
  static const Color outlineVariant = Color(0xFFC1C6D4);
  static const Color error = Color(0xFFBA1A1A);

  static ThemeData get theme {
    // Work Sans for Display/Headlines
    final displayFont = GoogleFonts.workSansTextTheme();
    // Inter for Body/Labels
    final bodyFont = GoogleFonts.interTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primary,
        primaryContainer: primaryContainer,
        onPrimary: onPrimary,
        secondary: secondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        surface: surface,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
        error: error,
      ),
      scaffoldBackgroundColor: surface,
      textTheme: TextTheme(
        displayLarge: displayFont.displayLarge?.copyWith(color: onSurface),
        displayMedium: displayFont.displayMedium?.copyWith(color: onSurface),
        displaySmall: displayFont.displaySmall?.copyWith(color: onSurface),
        headlineLarge: displayFont.headlineLarge?.copyWith(color: onSurface, fontWeight: FontWeight.bold, letterSpacing: -0.02),
        headlineMedium: displayFont.headlineMedium?.copyWith(color: onSurface, fontWeight: FontWeight.bold),
        headlineSmall: displayFont.headlineSmall?.copyWith(color: onSurface, fontWeight: FontWeight.bold),
        titleLarge: bodyFont.titleLarge?.copyWith(color: onSurface),
        titleMedium: bodyFont.titleMedium?.copyWith(color: onSurface),
        titleSmall: bodyFont.titleSmall?.copyWith(color: onSurface),
        bodyLarge: bodyFont.bodyLarge?.copyWith(color: onSurface),
        bodyMedium: bodyFont.bodyMedium?.copyWith(color: onSurfaceVariant),
        bodySmall: bodyFont.bodySmall?.copyWith(color: onSurfaceVariant),
        labelLarge: bodyFont.labelLarge?.copyWith(color: onSurface),
        labelMedium: bodyFont.labelMedium?.copyWith(color: onSurfaceVariant, letterSpacing: 1.05),
        labelSmall: bodyFont.labelSmall?.copyWith(color: onSurfaceVariant),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceContainerLow,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: onSurface),
        titleTextStyle: TextStyle(
          color: onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: outlineVariant.withValues(alpha: 0.15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primary.withValues(alpha: 0.2)),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: outlineVariant, // Ghost border fallback
        thickness: 1,
        space: 1,
      ),
    );
  }
}
