import 'package:flutter/material.dart';
import '../widgets/app_background.dart';
import '../widgets/soft_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  "HerSpace",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 30),

                SoftCard(
                  child: ListTile(
                    leading: Icon(Icons.chat_bubble_outline),
                    title: Text("Anonymous Chat"),
                    subtitle: Text("Share your thoughts"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),

                SoftCard(
                  child: ListTile(
                    leading: Icon(Icons.mood),
                    title: Text("Mood Tracker"),
                    subtitle: Text("Track your feelings"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
