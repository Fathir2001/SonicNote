import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

/// Builds Material 3 [ThemeData] for SonicNote.
class AppTheme {
  AppTheme._();

  // ───────────────────────── LIGHT ─────────────────────────────────
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.electricBlue,
      brightness: Brightness.light,
      primary: AppColors.electricBlue,
      secondary: AppColors.accentIndigo,
      tertiary: AppColors.neonPurple,
      surface: AppColors.nearWhite,
      error: AppColors.error,
    );

    return _base(colorScheme).copyWith(
      scaffoldBackgroundColor: AppColors.nearWhite,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.deepNavy,
        ),
        iconTheme: const IconThemeData(color: AppColors.deepNavy),
      ),
      cardTheme: CardTheme(
        color: AppColors.glassLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.glassBorderLight),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.electricBlue,
        foregroundColor: AppColors.pureWhite,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  // ───────────────────────── DARK ──────────────────────────────────
  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.electricBlue,
      brightness: Brightness.dark,
      primary: AppColors.softBlue,
      secondary: AppColors.accentIndigo,
      tertiary: AppColors.neonPurple,
      surface: const Color(0xFF101530),
      error: AppColors.error,
    );

    return _base(colorScheme).copyWith(
      scaffoldBackgroundColor: const Color(0xFF080E28),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.nearWhite,
        ),
        iconTheme: const IconThemeData(color: AppColors.nearWhite),
      ),
      cardTheme: CardTheme(
        color: AppColors.glassDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.glassBorderDark),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.accentIndigo,
        foregroundColor: AppColors.pureWhite,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  // ───────────────────────── BASE ──────────────────────────────────
  static ThemeData _base(ColorScheme scheme) {
    final textTheme = GoogleFonts.poppinsTextTheme(
      ThemeData(colorScheme: scheme).textTheme,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: textTheme,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
