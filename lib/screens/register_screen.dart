import 'package:flutter/material.dart';
import 'package:herspace_app/database/db_helper.dart';
import 'package:herspace_app/decorations/app_colors.dart';
import 'package:herspace_app/models/user_model.dart';
import 'role_selection_screen.dart';

class RegisterScreen extends StatefulWidget {
  final String role;

  RegisterScreen({super.key, required this.role});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool obscurePassword = true;

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String generateNickname() {
    List adjectives = [
      "Soft",
      "Quiet",
      "Gentle",
      "Brave",
      "Calm",
      "Kind",
      "Beautiful",
      "Happy",
      "Dreamy",
    ];

    List nouns = [
      "Moon",
      "River",
      "Tulip",
      "Sky",
      "Star",
      "Cloud",
      "Queen",
      "Elf",
      "Rose",
      "Lily",
      "Princess",
    ];

    adjectives.shuffle();
    nouns.shuffle();

    return "${adjectives.first}${nouns.first}";
  }

  Future<void> registerUser() async {

    if (!formKey.currentState!.validate()) return;

    String nickname = nicknameController.text;

    if (nickname.isEmpty) {
      nickname = generateNickname();
    }

    UserModel user = UserModel(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      phone: phoneController.text.trim(),
      role: widget.role,
      nickname: nickname,
      avatar: "😊",
    );

    await DBHelper.registerUser(user);

    showMessage("Welcome $nickname");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RoleSelectionScreenHp(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 28),

          child: Form(
            key: formKey,

            child: Column(
              children: [

                SizedBox(height: 60),

                /// LOGO
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      )
                    ],
                  ),
                  child: Image.asset(
                    "assets/images/logo_herspace-preview.png",
                    width: 90,
                    filterQuality: FilterQuality.high,
                  ),
                ),

                SizedBox(height: 24),

                /// TITLE
                Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  "Join HerSpace and start your journey",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),

                SizedBox(height: 40),

                /// REGISTER CARD
                Container(
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

                  child: Column(
                    children: [

                      /// NICKNAME
                      TextFormField(
                        controller: nicknameController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: "Anonymous Nickname (optional)",
                          filled: true,
                          fillColor: Color(0xFFF5F5F5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      SizedBox(height: 8),

                      TextButton.icon(
                        icon: Icon(Icons.casino),
                        label: Text("Generate Random Nickname"),
                        onPressed: () {
                          setState(() {
                            nicknameController.text = generateNickname();
                          });
                        },
                      ),

                      SizedBox(height: 18),

                      /// EMAIL
                      TextFormField(
                        controller: emailController,
                        validator: (value) {

                          if (value == null || value.isEmpty) {
                            return "Email is required";
                          }

                          if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return "Invalid email format";
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Email",
                          prefixIcon: Icon(Icons.email_outlined),
                          filled: true,
                          fillColor: Color(0xFFF5F5F5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      SizedBox(height: 18),

                      /// PASSWORD
                      TextFormField(
                        controller: passwordController,
                        obscureText: obscurePassword,
                        validator: (value) {

                          if (value == null || value.isEmpty) {
                            return "Password is required";
                          }

                          if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: Icon(Icons.lock_outline),
                          filled: true,
                          fillColor: Color(0xFFF5F5F5),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      SizedBox(height: 18),

                      /// PHONE
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {

                          if (value == null || value.isEmpty) {
                            return "Phone number is required";
                          }

                          if (value.length < 10) {
                            return "Invalid phone number";
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Phone Number",
                          prefixIcon: Icon(Icons.phone_outlined),
                          filled: true,
                          fillColor: Color(0xFFF5F5F5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      SizedBox(height: 24),

                      /// REGISTER BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: registerUser,
                          child: Text(
                            "Register",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}