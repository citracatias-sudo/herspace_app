import 'package:flutter/material.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Email: ${user.email}", style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 10),

            Text("Phone: ${user.phone}", style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 10),

            Text("Role: ${user.role}", style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
