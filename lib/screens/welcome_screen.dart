import 'package:flutter/material.dart';
import 'package:herspace_app/screens/login_screen.dart';


class WelcomeScreenHp extends StatelessWidget {
  const WelcomeScreenHp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/logo_herspace-removebg-preview.png",
            ),
            fit: BoxFit.contain,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 260),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (Route) => false,
                  );
                },

                child: Text("Start"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
