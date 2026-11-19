import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFF1B6B4A);
  static const primaryDark = Color(0xFF15533A);
  static const deep = Color(0xFF005235);
  static const secondary = Color(0xFF2CC082);
  static const mint = Color(0xFF70F8B5);
  static const mintSoft = Color(0xFF9CE9BF);
  static const tertiary = Color(0xFFF4A261);
  static const bg = Color(0xFFFBFBF7);
  static const text = Color(0xFF1A2420);
  static const slate = Color(0xFF526058);
  static const mintTint = Color(0xFFE3F5EC);
  static const surfaceLow = Color(0xFFEEF5F0);
  static const amberText = Color(0xFFB45309);
  static const amberTint = Color(0xFFFDEBD9);
  static const roseText = Color(0xFFB91C1C);
  static const roseTint = Color(0xFFFEE2E2);
}

TextStyle ts(double size,
    {FontWeight w = FontWeight.w400, Color? c, double? h}) {
  return GoogleFonts.plusJakartaSans(
    fontSize: size,
    fontWeight: w,
    color: c ?? AppColors.text,
    height: h,
  );
}

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: AppColors.tertiary,
    ),
    scaffoldBackgroundColor: AppColors.bg,
  );
  return base.copyWith(
    textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme)
        .apply(bodyColor: AppColors.text, displayColor: AppColors.text),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.text,
      contentTextStyle: ts(13, c: Colors.white, w: FontWeight.w500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
