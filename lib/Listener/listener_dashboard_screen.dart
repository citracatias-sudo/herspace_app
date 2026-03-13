import 'package:flutter/material.dart';
import 'package:herspace_app/decorations/app_colors.dart';
import 'package:herspace_app/screens/community_screen.dart';
import 'package:herspace_app/screens/messages_screen.dart';
import 'package:herspace_app/database/db_helper.dart';
import 'package:herspace_app/screens/login_screen.dart';
import '../models/user_model.dart';

class ListenerDashboardScreen extends StatefulWidget {
  final UserModel user;

  const ListenerDashboardScreen({super.key, required this.user});

  @override
  State<ListenerDashboardScreen> createState() =>
      _ListenerDashboardScreenState();
}

class _ListenerDashboardScreenState extends State<ListenerDashboardScreen> {
  bool isOnline = false;

  @override
  void initState() {
    super.initState();
    isOnline = widget.user.isOnline;
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text("Listener Dashboard"), centerTitle: true),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// PROFILE HEADER
            Container(
              padding: EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),

              child: Row(
                children: [
                  /// AVATAR
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        child: Text(
                          user.nickname.substring(0, 1),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      /// ONLINE DOT
                      if (isOnline)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            height: 14,
                            width: 14,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),

                  SizedBox(width: 16),

                  /// USER INFO + TOGGLE
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome back",
                          style: TextStyle(color: Colors.grey),
                        ),

                        Text(
                          user.nickname,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          "Listener",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        SizedBox(height: 6),

                        Row(
                          children: [
                            Text("Available to Listen"),

                            Switch(
                              value: isOnline,
                              onChanged: (value) async {
                                setState(() {
                                  isOnline = value;
                                });

                                await DBHelper.updateOnlineStatus(
                                  user.id!,
                                  value,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// LOGOUT
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 25),

            /// STATS
            Row(
              children: [
                Expanded(
                  child: statCard(
                    icon: Icons.star,
                    title: "Points",
                    value: "240",
                    color: Colors.orange,
                  ),
                ),

                SizedBox(width: 12),

                Expanded(
                  child: statCard(
                    icon: Icons.chat_bubble_outline,
                    title: "Active Chats",
                    value: "4",
                    color: Colors.pink,
                  ),
                ),

                SizedBox(width: 12),

                Expanded(
                  child: statCard(
                    icon: Icons.favorite,
                    title: "Helped",
                    value: "32",
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),

            SizedBox(height: 30),

            /// REQUESTS
            Text(
              "Users Waiting for Support",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 12),

            requestCard("AnonymousTulip"),
            requestCard("QuietMoon"),

            SizedBox(height: 30),

            /// ACTIVE CHATS
            FutureBuilder(
              future: DBHelper.getListenerRooms(user.id!),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final rooms = snapshot.data as List<Map<String, dynamic>>;

                if (rooms.isEmpty) {
                  return Text("No conversations yet");
                }

                return Column(
                  children: rooms.map((room) {
                    String roomId = room["roomId"];

                    return ListTile(
                      leading: CircleAvatar(child: Icon(Icons.person)),

                      title: Text("Speaker"),

                      subtitle: Text("Tap to open chat"),

                      trailing: Icon(Icons.mark_chat_unread, color: Colors.red),

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MessagesScreen(
                              roomId: roomId,
                              nickname: "Speaker",
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),

            /// QUICK ACTIONS
            Text(
              "Quick Actions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 12),

            Container(
              padding: EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),

              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.public),
                    title: Text("Community Chat"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessagesScreen(
                            roomId: "general",
                            nickname: widget.user.nickname,
                          ),
                        ),
                      );
                    },
                  ),

                  Divider(),

                  ListTile(
                    leading: Icon(Icons.favorite),
                    title: Text("Mental Health Resources"),
                    subtitle: Text("Helpful guides for listeners"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// STAT CARD
  Widget statCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),

      child: Column(
        children: [
          Icon(icon, color: color),

          SizedBox(height: 6),

          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  /// USER REQUEST CARD
  Widget requestCard(String name) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),

      child: ListTile(
        leading: CircleAvatar(child: Icon(Icons.person_outline)),
        title: Text(name),
        subtitle: Text("Waiting for a listener"),
        trailing: ElevatedButton(onPressed: () {}, child: Text("Accept")),
      ),
    );
  }

  /// CONVERSATION CARD
  Widget conversationCard(
    BuildContext context,
    String name,
    String preview,
    String roomId,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),

      child: ListTile(
        leading: CircleAvatar(child: Text(name.substring(0, 1))),
        title: Text(name),
        subtitle: Text(preview, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CommunityScreen(nickname: widget.user.nickname),
            ),
          );
        },
      ),
    );
  }
}
