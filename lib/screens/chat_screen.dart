import 'package:flutter/material.dart';
import 'package:herspace_app/decorations/app_colors.dart';
import '../database/db_helper.dart';
import '../models/chat_model.dart';

class ChatScreen extends StatefulWidget {
  final String nickname;
  const ChatScreen({super.key, required this.nickname});

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
      backgroundColor: Color(0xFFFFF4F8),

      appBar: AppBar(
        title: Text("HerSpace Chat"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: Column(
        children: [
          /// CHAT LIST
          Expanded(
            child: dataChat.isEmpty
                ? Center(
                    child: Text(
                      "Start the conversation 💬",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: dataChat.length,
                    itemBuilder: (context, index) {
                      final chat = dataChat[index];

                      bool isMe = chat.sender == widget.nickname;

                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,

                        child: GestureDetector(
                          onLongPress: () async {
                            if (chat.id == null) return;

                            await DBHelper.deleteMessage(chat.id!);
                            await getDataChat();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Message deleted")),
                            );
                          },

                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 6),
                            padding: EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),

                            decoration: BoxDecoration(
                              color: isMe ? AppColors.primary : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 4),
                              ],
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  chat.sender,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isMe ? Colors.white70 : Colors.grey,
                                  ),
                                ),

                                SizedBox(height: 4),

                                Text(
                                  chat.message,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: isMe ? Colors.white : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          /// INPUT CHAT
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
            ),

            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Share what's on your mind...",
                      filled: true,
                      fillColor: Color(0xFFFFF0F6),

                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 8),

                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () async {
                      if (messageController.text.trim().isEmpty) return;

                      final chat = ChatModel(
                        message: messageController.text,
                        sender: widget.nickname,
                      );

                      await DBHelper.insertMessage(chat);

                      messageController.clear();

                      await getDataChat();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
