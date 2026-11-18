import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';

/// Token warna dari DESIGN.md (Academic Treasury).
class AppColors {
  static const primary = Color(0xFF0F5132);
  static const primaryDark = Color(0xFF0B3D26);
  static const primaryMid = Color(0xFF157347);
  static const blue = Color(0xFF0D6EFD);
  static const gold = Color(0xFFD4A017);
  static const background = Color(0xFFF8FAFC);
  static const text = Color(0xFF1E293B);
  static const muted = Color(0xFF64748B);
  static const border = Color(0xFFE2E8F0);
  static const inputBorder = Color(0xFFCBD5E1);
  static const inflowBg = Color(0xFFDCFCE7);
  static const inflowBorder = Color(0xFFBBF7D0);
  static const outflow = Color(0xFFDC2626);
  static const outflowBg = Color(0xFFFEE2E2);
  static const outflowBorder = Color(0xFFFECACA);
  static const segmentBg = Color(0xFFE7EEFF);
}

/// Angka dengan lebar tetap (tabular) supaya rapi sejajar.
const angkaTabular = [FontFeature.tabularFigures()];

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(seedColor: AppColors.primary).copyWith(
    primary: AppColors.primary,
    onPrimary: Colors.white,
    secondary: AppColors.blue,
    tertiary: AppColors.gold,
    error: AppColors.outflow,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.background,
  );
}
