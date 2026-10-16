import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // Status tema: false = Light Mode, true = Dark Mode
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  // Dipakai di MaterialApp (themeMode)
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  // Ganti tema
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
