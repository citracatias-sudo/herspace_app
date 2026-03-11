import 'package:flutter/material.dart';
import 'package:herspace_app/decorations/app_colors.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Call a peers"),
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: Text(
          "Coming soon",
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
