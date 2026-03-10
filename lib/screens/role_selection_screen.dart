import 'package:flutter/material.dart';
import 'package:herspace_app/decorations/app_colors.dart';
import 'package:herspace_app/screens/login_screen.dart';

class RoleSelectionScreenHp extends StatelessWidget {
  RoleSelectionScreenHp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: Text("Choose Your Role"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: Padding(
        padding: EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),

            Text(
              "How would you like to use HerSpace?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Choose your role to begin your journey.",
              style: TextStyle(color: AppColors.textSecondary),
            ),

            SizedBox(height: 40),

            /// Speaker Card
            roleCard(
              context,
              icon: Icons.chat_bubble_outline,
              title: "Speaker",
              subtitle: "Share your feelings anonymously",
              color: AppColors.secondary,
              role: "speaker",
            ),

            SizedBox(height: 20),

            /// Listener Card
            roleCard(
              context,
              icon: Icons.support_agent,
              title: "Listener",
              subtitle: "Support someone who needs help",
              color: AppColors.primary,
              role: "listener",
            ),
          ],
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
        padding: EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),

          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),

        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),

              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),

              child: Icon(icon, size: 30, color: color),
            ),

            SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),

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
            borderRadius: BorderRadius.circular(16),
          ),

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
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
              ),

              onPressed: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
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
