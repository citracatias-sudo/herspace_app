import 'package:flutter/material.dart';

import 'package:herspace_app/screens/register_screen.dart';

class RoleSelectionScreenHp extends StatelessWidget {
  const RoleSelectionScreenHp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choose Role")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                showAgreement(context, "speaker");
              },
              child: Text("I am ready to share"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showAgreement(context, 'listener');
              },
              child: Text("I am ready to listen"),
            ),
          ],
        ),
      ),
    );
  }

  void showAgreement(BuildContext context, String role) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Community Agreement"),
          content: Text(
            role == "speaker"
                ? "Please respect others and keep conversations safe."
                : "As a listener, please provide respectful and supportive responses.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Decline"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterScreen(role: 'listener'),
                  ),
                );
              },
              child: Text("Accept"),
            ),
          ],
        );
      },
    );
  }
}
