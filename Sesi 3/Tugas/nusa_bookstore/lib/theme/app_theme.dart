import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Warna tambahan yang tidak ada di ColorScheme bawaan Flutter
/// (diambil dari design token "secondary-fixed" dan "on-tertiary-container").
extension NusaColors on ColorScheme {
  bool get isDark => brightness == Brightness.dark;

  /// Latar badge / chip kategori (terracotta lembut)
  Color get badgeBg =>
      isDark ? const Color(0xFF76330F) : const Color(0xFFFFDBCD);

  /// Teks badge / chip kategori
  Color get badgeFg =>
      isDark ? const Color(0xFFFFDBCD) : const Color(0xFF360F00);

  /// Warna bintang rating (gilded ochre)
  Color get star => isDark ? const Color(0xFFFDBA54) : const Color(0xFFC38825);
}

/// Dua keluarga font dari DESIGN.md:
/// - Newsreader (serif) untuk judul buku dan headline
/// - Plus Jakarta Sans untuk body, label, tombol, dan harga
class AppText {
  AppText._();

  static TextStyle serif(
    double size, {
    FontWeight weight = FontWeight.w600,
    Color? color,
    double? height,
    double? letterSpacing,
  }) =>
      GoogleFonts.newsreader(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );

  static TextStyle sans(
    double size, {
    FontWeight weight = FontWeight.w400,
    Color? color,
    double? height,
    double? letterSpacing,
  }) =>
      GoogleFonts.plusJakartaSans(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );
}

class AppTheme {
  AppTheme._();

  // ---------------- LIGHT (token persis dari template HTML) ----------------
  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF071637),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF1E2B4D),
    onPrimaryContainer: Color(0xFF8693BB),
    secondary: Color(0xFF944924),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFFE9E72),
    onSecondaryContainer: Color(0xFF77330F),
    tertiary: Color(0xFF241400),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFF3F2700),
    onTertiaryContainer: Color(0xFFC38825),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF93000A),
    surface: Color(0xFFFAF9F6),
    onSurface: Color(0xFF1A1C1A),
    onSurfaceVariant: Color(0xFF45464E),
    outline: Color(0xFF75777F),
    outlineVariant: Color(0xFFC6C6CF),
    inverseSurface: Color(0xFF2F312F),
    onInverseSurface: Color(0xFFF2F1EE),
    inversePrimary: Color(0xFFB9C5F0),
    surfaceTint: Color(0xFF515D82),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF4F3F0),
    surfaceContainer: Color(0xFFEFEEEB),
    surfaceContainerHigh: Color(0xFFE9E8E5),
    surfaceContainerHighest: Color(0xFFE3E2DF),
  );

  // ---------------- DARK (turunan dari palet yang sama) ----------------
  // Template hanya memberi palet light, jadi versi dark ini dibuat dari
  // varian "fixed" palet yang sama supaya warnanya tetap serasi.
  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFB9C5F0),
    onPrimary: Color(0xFF0C1A3B),
    primaryContainer: Color(0xFF1E2B4D),
    onPrimaryContainer: Color(0xFFB9C5F0),
    secondary: Color(0xFFFFB595),
    onSecondary: Color(0xFF541E00),
    secondaryContainer: Color(0xFF76330F),
    onSecondaryContainer: Color(0xFFFFDBCD),
    tertiary: Color(0xFFFDBA54),
    onTertiary: Color(0xFF452B00),
    tertiaryContainer: Color(0xFF624000),
    onTertiaryContainer: Color(0xFFFFDDB2),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF121412),
    onSurface: Color(0xFFE3E2DF),
    onSurfaceVariant: Color(0xFFC6C6CF),
    outline: Color(0xFF8F9099),
    outlineVariant: Color(0xFF45464E),
    inverseSurface: Color(0xFFE3E2DF),
    onInverseSurface: Color(0xFF2F312F),
    inversePrimary: Color(0xFF071637),
    surfaceTint: Color(0xFFB9C5F0),
    surfaceContainerLowest: Color(0xFF0D0F0D),
    surfaceContainerLow: Color(0xFF1A1C1A),
    surfaceContainer: Color(0xFF1E201E),
    surfaceContainerHigh: Color(0xFF292A28),
    surfaceContainerHighest: Color(0xFF343533),
  );

  static final ThemeData light = _build(_lightScheme);
  static final ThemeData dark = _build(_darkScheme);

  static ThemeData _build(ColorScheme cs) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      scaffoldBackgroundColor: cs.surface,
      dividerColor: cs.outlineVariant,
    );
  }
}
