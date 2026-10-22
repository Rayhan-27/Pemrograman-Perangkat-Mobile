import 'package:flutter/material.dart';

import '../models/tour_package.dart';
import '../screens/booking_screen.dart';
import '../screens/detail_screen.dart';
import '../screens/home_screen.dart';
import '../screens/not_found_screen.dart';
import '../screens/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String detail = '/detail';
  static const String booking = '/booking';

  /// Route statis (tanpa arguments).
  static Map<String, WidgetBuilder> get routes => {
        splash: (_) => const SplashScreen(),
        home: (_) => const HomeScreen(),
      };

  /// Route dinamis (butuh arguments). Jika arguments tidak valid,
  /// return null supaya Flutter memanggil onUnknownRoute (404).
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case detail:
        if (args is TourPackage) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => DetailScreen(tour: args),
          );
        }
        return null;
      case booking:
        if (args is TourPackage) {
          return MaterialPageRoute<BookingResult>(
            settings: settings,
            builder: (_) => BookingScreen(tour: args),
          );
        }
        return null;
    }
    return null;
  }

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => NotFoundScreen(routeName: settings.name),
    );
  }
}
