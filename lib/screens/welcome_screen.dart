import 'package:flutter/material.dart';
import 'role_selection_screen.dart';

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoleSelectionScreenHp(),
                    ),
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
