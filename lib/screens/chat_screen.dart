import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/chat_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();

  late List<ChatModel> dataChat = [];

  @override
  void initState() {
    super.initState();
    getDataChat();
  }

  Future<void> getDataChat() async {
    dataChat = await DBHelper.getMessages();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Anonymous Chat")),

      body: Column(
        children: [
          Expanded(
            child: dataChat.isEmpty
                ? Center(child: Text("No messages yet"))
                : ListView.builder(
                    itemCount: dataChat.length,
                    itemBuilder: (context, index) {
                      final chat = dataChat[index];

                      return ListTile(
                        title: Text(chat.message),
                        subtitle: Text(chat.sender),
                      );
                    },
                  ),
          ),

          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                    ),
                  ),
                ),

                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    if (messageController.text.trim().isEmpty) return;

                    final chat = ChatModel(
                      message: messageController.text,
                      sender: "User",
                    );

                    await DBHelper.insertMessage(chat);

                    messageController.clear();

                    await getDataChat();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
