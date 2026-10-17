import 'package:flutter/material.dart';
import 'brutal_tokens.dart';
import 'brutal_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final brutalTheme = BrutalTheme.light();

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: BrutalTokens.canvas,
      fontFamily: BrutalTokens.fontUi,
      colorScheme: const ColorScheme.light(
        primary: BrutalTokens.warn,
        onPrimary: BrutalTokens.ink,
        surface: BrutalTokens.canvas,
        onSurface: BrutalTokens.ink,
        error: BrutalTokens.danger,
        onError: BrutalTokens.ink,
      ),
      textTheme: const TextTheme(
        // Hero: Angka runway raksasa
        displayLarge: TextStyle(
          fontFamily: BrutalTokens.fontNumbers,
          fontSize: 96,
          fontWeight: FontWeight.w900,
          color: BrutalTokens.ink,
          height: 1.0,
        ),
        // Display: Unassigned / Nominal Besar
        displayMedium: TextStyle(
          fontFamily: BrutalTokens.fontNumbers,
          fontSize: 40,
          fontWeight: FontWeight.w800,
          color: BrutalTokens.ink,
        ),
        // H1: Judul Halaman
        headlineLarge: TextStyle(
          fontFamily: BrutalTokens.fontUi,
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: BrutalTokens.ink,
        ),
        // H2: Subjudul
        headlineMedium: TextStyle(
          fontFamily: BrutalTokens.fontUi,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: BrutalTokens.ink,
        ),
        // Body: Teks biasa
        bodyLarge: TextStyle(
          fontFamily: BrutalTokens.fontUi,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: BrutalTokens.ink,
        ),
        bodyMedium: TextStyle(
          fontFamily: BrutalTokens.fontUi,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: BrutalTokens.ink,
        ),
        // Label: Badge, Button, Header kolom
        labelLarge: TextStyle(
          fontFamily: BrutalTokens.fontUi,
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: BrutalTokens.ink,
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          fontFamily: BrutalTokens.fontUi,
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: BrutalTokens.ink,
          letterSpacing: 0.5,
        ),
      ),
      extensions: [brutalTheme],
    );
  }
}
