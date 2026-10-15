import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/catalog_screen.dart';

void main() {
  runApp(
    // MultiProvider di root: semua provider didaftarkan di sini
    MultiProvider( // MultiProvider dipakai karena kita punya lebih dari satu provider
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()), // bikin satu objek provider saat aplikasi mulai, dan parameter _ artinya contextnya nggak kita pakai
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        // CartProvider dan ThemeProvider didaftarkan sekaligus dalam satu list providers
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumer: MaterialApp otomatis rebuild saat tema berubah
    return Consumer<ThemeProvider>( // widget yang “mendengarkan” ThemeProvider
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'NusaBookstore',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.indigo,
              brightness: Brightness.dark,
            ),
          ),
          home: const CatalogScreen(), // ini menjadikan Katalog sebagai halaman pertama
        );
      },
    );
  }
}