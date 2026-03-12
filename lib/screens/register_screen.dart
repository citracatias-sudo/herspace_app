import 'package:flutter/material.dart';
import 'package:herspace_app/database/db_helper.dart';
import 'package:herspace_app/decorations/app_colors.dart';
import 'package:herspace_app/models/user_model.dart';
import 'package:herspace_app/screens/login_screen.dart';
import 'package:herspace_app/widgets/gradient_button.dart';
import 'role_selection_screen.dart';

class RegisterScreen extends StatefulWidget {
  final String role;

  const RegisterScreen({super.key, required this.role});

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
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
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

    try {
      String nickname = nicknameController.text;

      if (nickname.isEmpty) {
        nickname = generateNickname();
      }

      UserModel newUser = UserModel(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        phone: phoneController.text.trim(),
        role: widget.role,
        nickname: nickname,
        avatar: "😊",
      );

      await DBHelper.registerUser(newUser);

      final UserModel? user = await DBHelper.loginUser(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      showMessage("Welcome $nickname");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RoleSelectionScreenHp(user: user!),
        ),
      );
    } catch (e) {
      showMessage("Register failed: $e"); //print error
    }
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
                SizedBox(height: 30),

                /// LOGO
                Center(
                  child: Image.asset(
                    "assets/images/logo_herspace (2)-Photoroom.png",
                    width: 150,
                  ),
                ),

                SizedBox(height: 16),

                /// TITLE
                Text(
                  "JOIN THE COMMUNITY",
                  style: TextStyle(fontSize: 24, color: AppColors.textPrimary),
                ),

                SizedBox(height: 5),

                Text(
                  "Where it's easier to speak",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),

                SizedBox(height: 24),

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
                          hintText: "Choose a nickname",
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

                      SizedBox(height: 15),

                      /// EMAIL
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email is required";
                          }

                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
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

                      SizedBox(height: 15),

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

                      SizedBox(height: 15),

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
                      GradientButton(text: "Register", onPressed: registerUser),
                    ],
                  ),
                ),

                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have account?  "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign in",
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
