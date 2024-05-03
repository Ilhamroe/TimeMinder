import 'package:flutter/material.dart';
import 'package:mobile_time_minder/pages/home_page.dart';
import 'package:mobile_time_minder/pages/timer_page.dart';
import 'package:mobile_time_minder/pages/onBoarding_page.dart';
import 'package:mobile_time_minder/widgets/bottom_navigation.dart';
import 'package:mobile_time_minder/widgets/splash_screen.dart';

class AppRoutes {
  static const String splash = "/";
  static const String onboard = "/onboard";
  static const String navbar = "/navbar";
  static const String home = "/home";
  static const String listTimer = "/list_timer";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SplashScreen(),
        );

      case AppRoutes.navbar:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const NavbarBottom(),
        );

      case AppRoutes.onboard:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const OnboardingPage(),
        );

      case AppRoutes.home:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HomePage(),
        );

      case AppRoutes.listTimer:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const DetailListTimer(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
