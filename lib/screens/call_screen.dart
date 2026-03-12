import 'package:flutter/material.dart';
import 'package:herspace_app/decorations/app_colors.dart';
import 'package:lottie/lottie.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Voice Session")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              Icons.call,
              size: 80,
              color: AppColors.button,
            ),

            SizedBox(height: 20),
             Lottie.asset("assets/lottie_animations/Coming soon.json"),
            Text(
              "Voice call feature coming soon",
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 20),

            // ElevatedButton(
            //   child: Text("End Session"),
            //   onPressed: () {
            //     Navigator.pop(context);
            //   },
            // )
          ],
        ),
      ),
    );
  }
}
