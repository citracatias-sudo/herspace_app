import 'package:flutter/material.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF6F9),

      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Color(0xFFA78BFA),
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: EdgeInsets.all(20),

        child: Column(
          children: [
            /// AVATAR
            CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFFF9A8D4),

              child: Text(
                user.email[0].toUpperCase(),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            SizedBox(height: 10),

            Text(
              user.email,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 30),

            /// PROFILE CARD
            Container(
              padding: EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),

                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),

              child: Column(
                children: [
                  buildProfileItem(Icons.email_outlined, "Email", user.email),

                  Divider(),

                  buildProfileItem(Icons.phone_outlined, "Phone", user.phone),

                  Divider(),

                  buildProfileItem(Icons.person_outline, "Role", user.role),
                ],
              ),
            ),

            SizedBox(height: 30),

            /// LOGOUT BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFA78BFA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                onPressed: () {
                  Navigator.pop(context);
                },

                child: Text("Logout", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileItem(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFFA78BFA)),

        SizedBox(width: 12),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 12, color: Colors.grey)),

            Text(
              value,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }
}
