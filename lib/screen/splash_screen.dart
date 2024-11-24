// ignore_for_file: use_build_context_synchronously

import 'package:bec_app/screen/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:bec_app/utils/app_navigator.dart';
import 'package:bec_app/constant/app_preferences.dart';
import 'package:bec_app/screen/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
  }

  Future<void> _checkLoginStatus() async {
    String? token = await AppPreferences.getToken();
    if (token != null) {
      // User is already logged in, navigate to HomeScreen
      AppNavigator.replaceTo(
        context: context,
        screen: const HomeScreen(),
      );
    } else {
      // Navigate to LoginScreen after a delay
      Future.delayed(const Duration(seconds: 5), () {
        AppNavigator.replaceTo(
          context: context,
          screen: const LoginScreen(),
        );
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Image.asset('assets/logos/bec_logo.jpeg', width: 200),
        ),
      ),
    );
  }
}
