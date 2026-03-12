import 'package:flutter/material.dart';
import 'package:herspace_app/decorations/app_colors.dart';
import 'package:lottie/lottie.dart';
import '../database/db_helper.dart';
import '../models/chat_model.dart';

class ChatScreen extends StatefulWidget {
  final String nickname;
  final String roomId;
  final String listenerName;

  const ChatScreen({
    super.key,
    required this.nickname,
    required this.roomId,
    required this.listenerName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  DateTime? startSession;
  List<ChatModel> dataChat = [];

  @override
  void initState() {
    super.initState();
    startSession = DateTime.now();
    getDataChat();
  }

  void scrollToBottom() {
    Future.delayed(Duration(milliseconds: 150), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> getDataChat() async {
    dataChat = await DBHelper.getMessagesByRoom(widget.roomId);
    setState(() {});
    scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      /// APPBAR
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.white,

        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.secondary, AppColors.primary],
            ),
          ),
        ),

        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Icon(Icons.favorite, color: AppColors.secondary),
            ),

            SizedBox(width: 10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.listenerName, style: TextStyle(fontSize: 16)),

                Text(
                  "Online",
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),

      /// BODY
      body: Column(
        children: [
          /// CHAT LIST
          Expanded(
            child: dataChat.isEmpty
                ? Center(
                    child: Lottie.asset(
                      "assets/lottie_animations/empty box3 (1).json",
                      width: 220,
                    ),
                  )
                : ListView.builder(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    itemCount: dataChat.length,
                    itemBuilder: (context, index) {
                      final chat = dataChat[index];

                      bool isMe = chat.sender == widget.nickname;

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 6),

                        child: Row(
                          mainAxisAlignment: isMe
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,

                          crossAxisAlignment: CrossAxisAlignment.end,

                          children: [
                            /// AVATAR LISTENER
                            if (!isMe)
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: AppColors.secondary,
                                child: Icon(
                                  Icons.favorite,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),

                            if (!isMe) SizedBox(width: 8),

                            /// MESSAGE BUBBLE
                            Flexible(
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
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),

                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                        0.65,
                                  ),

                                  decoration: BoxDecoration(
                                    color: isMe
                                        ? AppColors.primary
                                        : Colors.white,

                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(18),
                                      topRight: Radius.circular(18),
                                      bottomLeft: Radius.circular(
                                        isMe ? 18 : 4,
                                      ),
                                      bottomRight: Radius.circular(
                                        isMe ? 4 : 18,
                                      ),
                                    ),

                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),

                                  child: Column(
                                    crossAxisAlignment: isMe
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,

                                    children: [
                                      Text(
                                        chat.message,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: isMe
                                              ? Colors.white
                                              : AppColors.textPrimary,
                                        ),
                                      ),

                                      SizedBox(height: 4),

                                      Text(
                                        chat.time,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: isMe
                                              ? Colors.white70
                                              : AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          /// MESSAGE INPUT
          Container(
            padding: EdgeInsets.fromLTRB(16, 10, 16, 16),

            decoration: BoxDecoration(
              color: Colors.white,

              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),

            child: Row(
              children: [
                /// INPUT BOX
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14),

                    decoration: BoxDecoration(
                      color: Color(0xFFFFF0F6),
                      borderRadius: BorderRadius.circular(30),
                    ),

                    child: TextField(
                      controller: messageController,
                      minLines: 1,
                      maxLines: 4,

                      decoration: InputDecoration(
                        hintText: "Share what's on your mind...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 10),

                /// SEND BUTTON
                GestureDetector(
                  onTap: () async {
                    if (messageController.text.trim().isEmpty) return;

                    final now = TimeOfDay.now();

                    final chat = ChatModel(
                      message: messageController.text,
                      sender: widget.nickname,
                      roomId: widget.roomId,
                      time: "${now.hour}:${now.minute}",
                    );

                    await DBHelper.insertMessage(chat);

                    messageController.clear();

                    await getDataChat();
                  },

                  child: Container(
                    height: 48,
                    width: 48,

                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.secondary, AppColors.primary],
                      ),
                      shape: BoxShape.circle,
                    ),

                    child: Icon(Icons.send, color: Colors.white),
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
