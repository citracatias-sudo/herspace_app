import 'package:flutter/material.dart';
import 'chat_screen.dart';

class MessagesScreen extends StatelessWidget {
  final String nickname;

  const MessagesScreen({super.key, required this.nickname});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> listeners = [
      {
        "name": "Listener Maya",
        "roomId": "room_maya",
      },
      {
        "name": "Listener Sarah",
        "roomId": "room_sarah",
      },
      {
        "name": "Listener Aisha",
        "roomId": "room_aisha",
      },
       {
        "name": "Listener Bella",
        "roomId": "room_bella",
      },
       {
        "name": "Listener Jessie",
        "roomId": "room_jessie",
      },
       {
        "name": "Listener Nami",
        "roomId": "room_nami",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title:  Text("Messages"),
        centerTitle: true,
      ),

      body: ListView.builder(
        itemCount: listeners.length,
        itemBuilder: (context, index) {
          final listener = listeners[index];

          return ListTile(
            leading:  CircleAvatar(
              child: Icon(Icons.person_outline_outlined),
            ),

            title: Text(listener["name"]!),

            subtitle:  Text("Tap to start conversation"),

            trailing:  Icon(Icons.chat),

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    nickname: nickname,
                    roomId: listener["roomId"]!,
                    listenerName: listener['name']!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}