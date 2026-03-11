import 'package:flutter/material.dart';
import 'package:herspace_app/decorations/app_colors.dart';
import '../database/db_helper.dart';
import '../models/chat_model.dart';

class ChatScreen extends StatefulWidget {
  final String nickname;
  final String roomId;
  final String listenerName;
  const ChatScreen({super.key, 
  required this.nickname, 
  required this.roomId,
  required this.listenerName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  late List<ChatModel> dataChat = [];

  @override
  void initState() {
    super.initState();
    getDataChat();
  }
//auto scroll
  void scrollToBottom() {
  Future.delayed( Duration(milliseconds: 200), () {
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
      backgroundColor: Color(0xFFFFF4F8),

      appBar: AppBar(
  backgroundColor: AppColors.button,
  foregroundColor: Colors.white,
  elevation: 0,

  title: Row(
    children: [

      CircleAvatar(
        radius: 18,
        backgroundColor: Colors.white,
        child: Icon(Icons.auto_awesome, color: Colors.amber),
      ),

      SizedBox(width: 10),

      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
          widget.listenerName,
          style: TextStyle(fontSize: 16),
        ),
          Text(
            "Online",
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    ],
  ),
),

      body: Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFFFF4F8),
        Color(0xFFFFE6F0),
      ],
    ),
  ),
  child: Column(
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
                  controller: scrollController,
                    padding: EdgeInsets.all(20),
                    itemCount: dataChat.length,
                    itemBuilder: (context, index) {
                      final chat = dataChat[index];

                      bool isMe = chat.sender == widget.nickname;

                      return Row(
  mainAxisAlignment:
      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
  crossAxisAlignment: CrossAxisAlignment.end,
  children: [

    if (!isMe)
      CircleAvatar(
        radius: 16,
        backgroundColor: Color(0xFFFFD6E7),
        child: Icon(Icons.favorite, size: 16, color: Colors.white),
      ),

    if (!isMe) SizedBox(width: 8),

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
          margin: EdgeInsets.symmetric(vertical: 6),
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          constraints: BoxConstraints(maxWidth: 260),

          decoration: BoxDecoration(
            color: isMe ? AppColors.primary: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(isMe ? 16 : 4),
              bottomRight: Radius.circular(isMe ? 4 : 16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              )
            ],
          ),

          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [

              Text(
                chat.message,
                style: TextStyle(
                  fontSize: 15,
                  color: isMe ? Colors.white : Colors.black87,
                ),
              ),

              SizedBox(height: 4),

              Text(
                chat.time,
                style: TextStyle(
                  fontSize: 10,
                  color: isMe ?  Color.fromARGB(179, 30, 30, 30) : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ],
);
                    },
                  ),
          ),

          /// INPUT CHAT
          Container(
  padding: EdgeInsets.fromLTRB(16, 10, 16, 16),
  decoration: BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 8,
        offset: Offset(0, -2),
      )
    ],
  ),
  child: Row(
    children: [

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
            color: AppColors.secondary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.send,
            color: Colors.white,
          ),
        ),
      ),
    ],
  ),
),
        ],
      ),
      ),
    );
  }
}
