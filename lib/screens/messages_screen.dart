import 'package:flutter/material.dart';
import 'package:herspace_app/decorations/app_colors.dart';
import 'chat_screen.dart';
import '../models/chat_model.dart';
import '../database/db_helper.dart';

class MessagesScreen extends StatefulWidget {
  final String nickname;

  const MessagesScreen({super.key, required this.nickname});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List<ChatModel> lastMessages = [];

  @override
  void initState() {
    super.initState();
    loadLastMessages();
  }

  Future<void> loadLastMessages() async {
    lastMessages = await DBHelper.getLastMessages();
    setState(() {});
  }

  ChatModel? getLastMessage(String roomId) {
    try {
      return lastMessages.firstWhere((chat) => chat.roomId == roomId);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> listeners = [
      {"name": "Listener Maya", "roomId": "room_maya", "online": true},
      {"name": "Listener Sarah", "roomId": "room_sarah", "online": false},
      {"name": "Listener Aisha", "roomId": "room_aisha", "online": true},
      {"name": "Listener Bella", "roomId": "room_bella", "online": false},
      {"name": "Listener Jessie", "roomId": "room_jessie", "online": true},
      {"name": "Listener Nami", "roomId": "room_nami", "online": false},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: Text("Messages"),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.secondary, AppColors.primary],
            ),
          ),
        ),
      ),

      body: Column(
        children: [
          /// SEARCH BAR
          Padding(
            padding: EdgeInsets.all(16),

            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),

              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                  hintText: "Search conversations...",
                ),
              ),
            ),
          ),

          /// CHAT LIST
          Expanded(
            child: ListView.builder(
              itemCount: listeners.length,

              itemBuilder: (context, index) {
                final listener = listeners[index];
                final lastMessage = getLastMessage(listener["roomId"]);

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),

                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            nickname: widget.nickname,
                            roomId: listener["roomId"],
                            listenerName: listener["name"],
                          ),
                        ),
                      ).then((_) {
                        loadLastMessages();
                      });
                    },

                    child: Container(
                      padding: EdgeInsets.all(14),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),

                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 6),
                        ],
                      ),

                      child: Row(
                        children: [
                          /// AVATAR
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 26,
                                backgroundColor: AppColors.secondary,
                                child: Text(
                                  listener["name"][9],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              if (listener["online"])
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    height: 12,
                                    width: 12,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          SizedBox(width: 14),

                          /// MESSAGE INFO
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  listener["name"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),

                                SizedBox(height: 4),

                                Text(
                                  lastMessage?.message ??
                                      "Tap to start conversation",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,

                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// TIME
                          Text(
                            lastMessage?.time ?? "",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
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
        ],
      ),
    );
  }
}
