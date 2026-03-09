import 'package:flutter/material.dart';
import '../widgets/app_background.dart';
import '../widgets/soft_card.dart';
import '../models/user_model.dart';
import 'chat_screen.dart';
import 'mood_tracker_screen.dart';

class HomeScreen extends StatelessWidget {
  final UserModel user;

  const HomeScreen({super.key, required this.user});

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

                if (user.role == "speaker") ...[
                  SoftCard(
                    child: ListTile(
                      leading: Icon(Icons.chat_bubble_outline),
                      title: Text("Have Chat"),
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MoodTrackerScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ] else ...[
                  SoftCard(
                    child: ListTile(
                      leading: Icon(Icons.support_agent),
                      title: Text("Listener Dashboard"),
                      subtitle: Text("Help people who need support"),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChatScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
