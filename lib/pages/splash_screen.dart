import 'package:flutter/material.dart';
import 'package:mobile_time_minder/services/onboarding_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );
    animation.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    animationController.forward();
    Future.delayed(const Duration(seconds: 2), () {
      checkFirstSeen();
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<void> checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = (prefs.getBool('seen') ?? false);
    if (seen) {
      Navigator.popAndPushNamed(context, AppRoutes.home);
    } else {
      await prefs.setBool('seen', true);
      Navigator.popAndPushNamed(context, AppRoutes.onboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Center(
          child: Image.asset(
            'assets/images/splash1.png',
            height: animation.value * 200,
          ),
        ),
      ),
    );
  }
}
