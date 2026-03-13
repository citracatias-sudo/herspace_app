import 'package:flutter/material.dart';
import 'package:herspace_app/database/db_helper.dart';
import 'package:herspace_app/decorations/app_colors.dart';
import 'package:herspace_app/models/user_model.dart';
import 'package:herspace_app/screens/login_screen.dart';

class RoleSelectionScreenHp extends StatefulWidget {
  final UserModel user;
  const RoleSelectionScreenHp({super.key, required this.user});

  @override
  State<RoleSelectionScreenHp> createState() => _RoleSelectionScreenHpState();
}

class _RoleSelectionScreenHpState extends State<RoleSelectionScreenHp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28),

          child: Column(
            children: [
              SizedBox(height: 40),

              /// LOGO
              Image.asset(
                "assets/images/logo_herspace (2)-Photoroom.png",
                width: 180,
                filterQuality: FilterQuality.high,
              ),

              SizedBox(height: 24),

              /// TITLE
              Text(
                "Choose Your Role",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              SizedBox(height: 10),

              Text(
                "How would you like to use HerSpace?",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),

              SizedBox(height: 50),

              /// SPEAKER CARD
              roleCard(
                context,
                icon: Icons.chat_bubble_outline,
                title: "Speaker",
                subtitle:
                    "Share your feelings anonymously and express what’s on your mind safely.",
                color: AppColors.secondary,
                role: "speaker",
              ),

              SizedBox(height: 20),

              /// LISTENER CARD
              roleCard(
                context,
                icon: Icons.support_agent,
                title: "Listener",
                subtitle:
                    "Support others by listening and giving kind responses.",
                color: AppColors.primary,
                role: "listener",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget roleCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required String role,
  }) {
    return GestureDetector(
      onTap: () {
        showAgreement(context, role);
      },

      child: Container(
        padding: EdgeInsets.all(22),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),

          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 14,
              offset: Offset(0, 6),
            ),
          ],
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ICON
            Container(
              padding: EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),

              child: Icon(icon, size: 28, color: color),
            ),

            SizedBox(width: 18),

            /// TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(height: 6),

                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 10),

            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary,
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),

          title: Text(
            "Community Agreement",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          content: Text(
            role == "speaker"
                ? "Please respect others and keep conversations safe and kind."
                : "As a listener, you will receive short-training-course and assessment to interact with speakers.",
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Decline"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              onPressed: () async {
                Navigator.pop(context);

                if (widget.user.id != null) {
                  await DBHelper.updateUserRole(widget.user.id!, role);
                }

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
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
