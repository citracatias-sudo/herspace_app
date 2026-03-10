import 'package:flutter/material.dart';
import 'package:herspace_app/decorations/app_colors.dart';
import 'package:herspace_app/screens/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                children: [
                  Center(
                    child: Text(
                      "Welcome to HerSpace",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Share your feelings safely",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Connect with supportive listeners",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [buildDot(0), buildDot(1), buildDot(2)],
            ),

            SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text("Get Started"),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDot(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      width: currentPage == index ? 12 : 8,
      height: currentPage == index ? 12 : 8,
      decoration: BoxDecoration(
        color: currentPage == index ? AppColors.primary : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}
