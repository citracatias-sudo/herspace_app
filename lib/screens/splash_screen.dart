import 'package:flutter/material.dart';
import 'package:herspace_app/screens/onboarding_screen.dart';

class SplashScreenHp extends StatefulWidget {
  const SplashScreenHp({super.key});

  @override
  State<SplashScreenHp> createState() => _SplashScreenHpState();
}

class _SplashScreenHpState extends State<SplashScreenHp> {
  @override
  void initState() {
    super.initState();
    startSplash();
  }

  void startSplash() async {
    await Future.delayed(const Duration(seconds: 3));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/logo_herspace-preview.png'),
      ),
    );
  }
}
