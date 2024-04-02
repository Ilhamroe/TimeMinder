import 'package:flutter/material.dart';
import 'package:mobile_time_minder/services/onboarding_routes.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MaterialApp(
        initialRoute: AppRoutes.splash, //splash screen will come first as it is define here
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
