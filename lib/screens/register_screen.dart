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

  bool obscurePassword = true;

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
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        phoneController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Form can't be empty")));

      return;
    }

    String nickname = nicknameController.text;

    if (nickname.isEmpty) {
      nickname = generateNickname();
    }

    UserModel user = UserModel(
      email: emailController.text,
      password: passwordController.text,
      phone: phoneController.text,
      role: widget.role,
      nickname: nickname,
    );

    await DBHelper.registerUser(user);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Welcome $nickname")));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RoleSelectionScreenHp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24, 48, 24, 30),

          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(30),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
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
                    SizedBox(height: 20),

                    Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 6),

                    Text(
                      "Join HerSpace and start your journey",
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 30),

                    /// Avatar Preview
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xFFFFE4F0),
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: AppColors.button,
                      ),
                    ),

                    SizedBox(height: 10),

                    /// Nickname field
                    TextFormField(
                      controller: nicknameController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "Anonymous Nickname",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    SizedBox(height: 5),

                    /// Generate button
                    TextButton.icon(
                      icon: Icon(Icons.casino),
                      label: Text("Generate Random Nickname"),
                      onPressed: () {
                        setState(() {
                          nicknameController.text = generateNickname();
                        });
                      },
                    ),

                    SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Email",
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    TextFormField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: Icon(Icons.lock_outline),

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
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        hintText: "Phone Number",
                        prefixIcon: Icon(Icons.phone_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: registerUser,
                        child: Text("Register", style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
