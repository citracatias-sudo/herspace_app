import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/chat_model.dart';
import '../decorations/app_colors.dart';
import 'chat_screen.dart';

class MessagesScreen extends StatefulWidget {
  final String roomId;
  final String nickname;

  const MessagesScreen({
    super.key,
    required this.roomId,
    required this.nickname,
  });

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Messages"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.secondary, AppColors.primary],
            ),
          ),
        ),
      ),

      body: FutureBuilder(
        future: DBHelper.getLastMessages(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final chats = snapshot.data as List<ChatModel>;

          if (chats.isEmpty) {
            return const Center(child: Text("No conversations yet"));
          }

          return ListView.builder(
            itemCount: chats.length,

            itemBuilder: (context, index) {
              final chat = chats[index];

              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),

                title: Text(chat.sender),

                subtitle: Text(
                  chat.message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                trailing: Text(chat.time, style: const TextStyle(fontSize: 12)),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        roomId: chat.roomId,
                        nickname: widget.nickname,
                        listenerName: chat.sender,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
