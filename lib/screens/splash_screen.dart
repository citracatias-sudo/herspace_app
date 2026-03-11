import 'package:flutter/material.dart';
import 'package:herspace_app/decorations/app_colors.dart';
import 'package:herspace_app/screens/onboarding_screen.dart';

class SplashScreenHp extends StatefulWidget {
  SplashScreenHp({super.key});

  @override
  State<SplashScreenHp> createState() => _SplashScreenHpState();
}

class _SplashScreenHpState extends State<SplashScreenHp>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  late Animation<double> opacityAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );

    scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));

    controller.forward();

    startSplash();
  }

  void startSplash() async {
    await Future.delayed(Duration(seconds: 3));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => OnboardingScreen()),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              // AppColors.primary.withOpacity(0.75),
              Color.fromARGB(255, 212, 189, 216),
              Color.fromARGB(255, 254, 254, 255),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: opacityAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// LOGO
                  Image.asset(
                    'assets/images/logo_herspace (2)-Photoroom.png',
                    width: 400,
                    filterQuality: FilterQuality.high,
                  ),

                  SizedBox(height: 24),

                  /// APP NAME
                  // Text(
                  //   "HerSpace",
                  //   style: TextStyle(
                  //     fontSize: 34,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.white,
                  //     letterSpacing: 1,
                  //   ),
                  // ),

                  // SizedBox(height: 8),

                  // /// TAGLINE
                  // Text(
                  //   "A safe space for every woman",
                  //   style: TextStyle(
                  //     fontSize: 15,
                  //     color: Colors.white.withOpacity(0.9),
                  //     letterSpacing: 0.5,
                  //   ),
                  // ),
                  SizedBox(height: 30),

                  /// LOADING
                  SizedBox(
                    width: 26,
                    height: 26,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
