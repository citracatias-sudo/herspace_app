import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../database/db_helper.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<String> avatars = [
    "😊",
    "😎",
    "🌸",
    "🌙",
    "🐱",
    "🐰",
    "🐼",
    "🍓",
    "⭐",
    "🦋",
  ];

  String selectedAvatar = "😊";

  @override
  void initState() {
    super.initState();
    selectedAvatar = widget.user.avatar;
  }

  void showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),

      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(20),

          child: GridView.builder(
            shrinkWrap: true,

            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
            ),

            itemCount: avatars.length,

            itemBuilder: (context, index) {
              String avatar = avatars[index];

              return GestureDetector(
                onTap: () async {
                  setState(() {
                    selectedAvatar = avatar;
                  });

                  await DBHelper.updateAvatar(widget.user.id!, avatar);

                  Navigator.pop(context);
                },

                child: Container(
                  margin: EdgeInsets.all(6),

                  decoration: BoxDecoration(
                    color: Colors.pink[50],
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Center(
                    child: Text(avatar, style: TextStyle(fontSize: 24)),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

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
            GestureDetector(
              onTap: showAvatarPicker,

              child: CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFFF9A8D4),

                child: Text(selectedAvatar, style: TextStyle(fontSize: 28)),
              ),
            ),

            SizedBox(height: 10),

            Text(
              widget.user.nickname,
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
                  buildProfileItem(
                    Icons.email_outlined,
                    "Email",
                    widget.user.email,
                  ),

                  Divider(),

                  buildProfileItem(
                    Icons.phone_outlined,
                    "Phone",
                    widget.user.phone,
                  ),

                  Divider(),

                  buildProfileItem(
                    Icons.person_outline,
                    "Role",
                    widget.user.role,
                  ),
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
