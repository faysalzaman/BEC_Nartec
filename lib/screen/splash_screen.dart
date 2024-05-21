import 'package:bec_app/screen/login/login_screen.dart';
import 'package:bec_app/utils/app_navigator.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    // after 3 seconds move to the login screen
    Future.delayed(const Duration(seconds: 3), () {
      AppNavigator.goToPage(context: context, screen: const LoginScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // make a splash screen with white background and and image in center
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/logos/bec_logo.jpeg'),
      ),
    );
  }
}
