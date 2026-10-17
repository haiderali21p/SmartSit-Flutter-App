import 'package:flutter/material.dart';

class SmartSitColors {
  static const Color green = Color(0xFF006E2F);
  static const Color greenDark = Color(0xFF005A25);
  static const Color ink = Color(0xFF0C0F10);
  static const Color text = Color(0xFF2B3437);
  static const Color muted = Color(0xFF586064);
  static const Color softText = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E9EC);
  static const Color panel = Color(0xFFF1F4F6);
  static const Color canvas = Color(0xFFF8F9FA);
  static const Color white = Color(0xFFFFFFFF);
  static const Color red = Color(0xFFBA1B24);
  static const Color redLight = Color(0xFFFDE8E8);
  static const Color greenLight = Color(0xFFE8F5EC);
}

class SmartSitTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: SmartSitColors.green,
      primary: SmartSitColors.green,
      surface: SmartSitColors.white,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: SmartSitColors.canvas,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: SmartSitColors.canvas,
        foregroundColor: SmartSitColors.text,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: SmartSitColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: SmartSitColors.border),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SmartSitColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: SmartSitColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: SmartSitColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: SmartSitColors.green, width: 1.4),
        ),
        labelStyle: const TextStyle(color: SmartSitColors.muted, fontSize: 14),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: SmartSitColors.ink,
          foregroundColor: SmartSitColors.white,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: SmartSitColors.text,
          side: const BorderSide(color: SmartSitColors.border),
          minimumSize: const Size(0, 44),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      dividerColor: SmartSitColors.border,
    );
  }
}
