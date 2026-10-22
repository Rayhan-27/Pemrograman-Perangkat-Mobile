import 'package:flutter/material.dart';

import 'routes/app_routes.dart';

void main() {
  runApp(const NusaTravelApp());
}

class NusaTravelApp extends StatelessWidget {
  const NusaTravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NusaTravel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF005C55),
          primary: const Color(0xFF005C55),
          tertiary: const Color(0xFF893A00),
        ),
        scaffoldBackgroundColor: const Color(0xFFFAF8FF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFAF8FF),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      onUnknownRoute: AppRoutes.onUnknownRoute,
    );
  }
}
