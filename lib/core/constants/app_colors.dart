import 'package:flutter/material.dart';

/// SonicNote brand colors — derived from official logo palette.
class AppColors {
  AppColors._();

  // ── Brand primaries ──────────────────────────────────────────────
  static const Color electricBlue = Color(0xFF3194FD);
  static const Color softBlue = Color(0xFF4D96FE);
  static const Color accentIndigo = Color(0xFF595EFD);
  static const Color neonPurple = Color(0xFFA052FC);
  static const Color magentaPurple = Color(0xFFC753FD);

  // ── Neutrals ─────────────────────────────────────────────────────
  static const Color deepNavy = Color(0xFF0A194C);
  static const Color nearWhite = Color(0xFFF8F8FE);
  static const Color pureWhite = Color(0xFFFFFFFF);

  // ── Functional ───────────────────────────────────────────────────
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFFFA726);

  // ── Gradient (Blue → Purple) ─────────────────────────────────────
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [electricBlue, accentIndigo, neonPurple],
  );

  static const LinearGradient brandGradientHorizontal = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [electricBlue, neonPurple],
  );

  // ── Glass effects ────────────────────────────────────────────────
  /// Light mode glass card: navy 6-12% opacity
  static Color glassLight = deepNavy.withValues(alpha: 0.08);
  static Color glassBorderLight = pureWhite.withValues(alpha: 0.15);

  /// Dark mode glass card: white 8-18% opacity
  static Color glassDark = pureWhite.withValues(alpha: 0.10);
  static Color glassBorderDark = pureWhite.withValues(alpha: 0.14);
}
