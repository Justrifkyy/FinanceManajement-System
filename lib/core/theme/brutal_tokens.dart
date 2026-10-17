import 'package:flutter/material.dart';

/// Design tokens untuk Neo-Brutalism style Runway Finance.
/// Sesuai dengan spesifikasi docs/DESIGN_SYSTEM.md.
class BrutalTokens {
  BrutalTokens._();

  // --- 1. Palet Warna (Light Mode v1) ---
  static const Color ink = Color(0xFF111111);
  static const Color canvas = Color(0xFFF5F0E6);
  static const Color paper = Color(0xFFFFFFFF);

  // Status & Health Bar
  static const Color safe = Color(0xFF5BE584);
  static const Color warn = Color(0xFFFFD43B);
  static const Color danger = Color(0xFFFF5C5C);

  // Kategori Amplop
  static const Color needs = Color(0xFF74B9FF);
  static const Color wants = Color(0xFFFF9EDB);
  static const Color buffer = Color(0xFFB197FC);
  static const Color goal = Color(0xFFFFA94D);

  // Teks & State
  static const Color muted = Color(0xFF4A4A4A);
  static const Color disabled = Color(0xFFD9D4C7);
  static const Color disabledText = Color(0xFF8A8577);

  // --- 2. Border Width ---
  static const double borderThin = 2.0;
  static const double borderBase = 3.0;
  static const double borderHeavy = 4.0;

  // --- 3. Hard Shadow Offsets (x=y, blur 0, color ink) ---
  static const double shadowSm = 3.0;
  static const double shadowMd = 5.0;
  static const double shadowLg = 8.0;

  static List<BoxShadow> hardShadow({double offset = shadowMd, Color color = ink}) {
    return [
      BoxShadow(
        color: color,
        offset: Offset(offset, offset),
        blurRadius: 0,
        spreadRadius: 0,
      ),
    ];
  }

  // --- 4. Radius ---
  static const BorderRadius radiusZero = BorderRadius.zero;

  // --- 5. Spacing ---
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 12.0;
  static const double spaceLg = 16.0;
  static const double spaceXl = 24.0;
  static const double spaceXxl = 32.0;

  // Screen Padding
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: spaceLg);

  // --- 6. Font Families ---
  static const String fontUi = 'SpaceGrotesk';
  static const String fontNumbers = 'SpaceMono';
}
