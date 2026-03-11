import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'chat_screen.dart';

class ListenerDashboardScreen extends StatelessWidget {
  final UserModel user;

  const ListenerDashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Listener Dashboard")),

      body: Padding(
        padding: EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome, ${user.nickname}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 30),

            Text(
              "Community Messages",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(nickname: user.nickname, roomId: "community_room",listenerName: "nanti isi",),
                  ),
                );
              },
              child: Text("Open Community Chat"),
            ),
          ],
        ),
      ),
    );
  }
}
