import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // Status tema: false = Light Mode, true = Dark Mode
  bool _isDarkMode = false; // _isDarkMode adalah status tema, karena dia false, defaultnya Light Mode

  bool get isDarkMode => _isDarkMode;

  // Dipakai di MaterialApp (themeMode)
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light; // getter yang ngubah status bool tadi jadi ThemeMode.dark atau ThemeMode.light

  // Ganti tema
  void toggleTheme() { // toggleTheme() membalik nilai _isDarkMode dengan ! 
    _isDarkMode = !_isDarkMode;
    notifyListeners(); // ngabarin widget yang lagi “mendengarkan” ThemeProvider supaya rebuild, jadi tema bisa langsung berubah tanpa harus restart aplikasi
  }
}