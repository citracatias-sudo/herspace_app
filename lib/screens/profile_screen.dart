import 'package:flutter/material.dart';
import 'package:herspace_app/decorations/app_colors.dart';
import 'package:herspace_app/screens/login_screen.dart';
import 'package:herspace_app/widgets/gradient_button.dart';
import '../models/user_model.dart';
import '../database/db_helper.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController emailController;
  late TextEditingController phoneController;

  List<String> avatars = [
    "😊","😎","🌸","🌙","🐱","🐰","🐼","🍓","⭐","🦋","🌷","🌹","🍂","🌺","☯️"
  ];

  String selectedAvatar = "😊";
  bool isOnline = false;

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController(text: widget.user.phone);
    emailController = TextEditingController(text: widget.user.email);
    selectedAvatar = widget.user.avatar;

    isOnline = widget.user.isOnline;
  }

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void showAvatarPicker() {
    showModalBottomSheet(
      context: context,
    
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(20),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
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

  void editEmail() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Email"),
          content: TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: "Email"),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text("Save"),
              onPressed: () async {
                await DBHelper.updateUser(
                  widget.user.id!,
                  emailController.text,
                  phoneController.text,
                );
                setState(() {});
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void editPhone() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Phone"),
          content: TextField(
            controller: phoneController,
            decoration: InputDecoration(labelText: "Phone"),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text("Save"),
              onPressed: () async {
                await DBHelper.updateUser(
                  widget.user.id!,
                  emailController.text,
                  phoneController.text,
                );
                setState(() {});
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  Widget buildStat(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        )
      ],
    );
  }

  Widget buildProfileItem(
    IconData icon,
    String title,
    String value, {
    VoidCallback? onEdit,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary),
        SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
              Text(value,
                  style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
        ),

        if (onEdit != null)
          IconButton(
            icon: Icon(Icons.edit_outlined, color: AppColors.secondary),
            onPressed: onEdit,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.secondary, AppColors.primary],
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [

            /// HEADER
            Container(
              padding: EdgeInsets.fromLTRB(20, 40, 20, 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.secondary, AppColors.primary],
              ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [

                  GestureDetector(
                    onTap: showAvatarPicker,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.pink[50],
                        child: Text(
                          selectedAvatar,
                          style: TextStyle(fontSize: 34),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  Text(
                    widget.user.nickname,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 6),

                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.user.role == "listener"
                          ? "Listener 🎧"
                          : "Speaker 💬",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            /// STATS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildStat("Sessions", "12"),
                buildStat("Rating", "⭐4.8"),
                buildStat("Community", "5"),
              ],
            ),

            SizedBox(height: 25),

            /// LISTENER ONLINE
            if (widget.user.role == "listener")
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 8)
                  ],
                ),
                child: SwitchListTile(
                title: Text("Available to Listen"),
                subtitle: Text("Turn on to receive speaker requests"),
                value: isOnline,
                onChanged: (value) async {

                  setState(() {
                    isOnline = value;
                  });

                  await DBHelper.updateOnlineStatus(
                    widget.user.id!,
                    value,
                  );

                },
              )
            ),

            /// PROFILE CARD
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [

                  buildProfileItem(
                    Icons.email_outlined,
                    "Email",
                    emailController.text,
                    onEdit: editEmail,
                  ),

                  Divider(),

                  buildProfileItem(
                    Icons.phone_outlined,
                    "Phone",
                    phoneController.text,
                    onEdit: editPhone,
                  ),

                  Divider(),

                  buildProfileItem(
                    Icons.person_outline,
                    "Role",
                    widget.user.role.toUpperCase(),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            /// LOGOUT
            GradientButton(
              text: "Logout",
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}