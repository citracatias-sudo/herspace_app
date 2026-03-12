import 'package:flutter/material.dart';
import 'package:herspace_app/decorations/app_colors.dart';
import 'package:herspace_app/screens/messages_screen.dart';
import '../models/user_model.dart';

class ListenerDashboardScreen extends StatelessWidget {
  final UserModel user;

  const ListenerDashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
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

                  Column(
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
                    ],
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
            Text(
              "Active Conversations",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 12),

            conversationCard(
              context,
              "GentleRose",
              "I feel really overwhelmed today...",
              "room_rose",
            ),

            conversationCard(
              context,
              "SoftSky",
              "Thank you for listening yesterday",
              "room_sky",
            ),

            SizedBox(height: 30),

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
                            nickname: user.nickname,
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
              builder: (context) => MessagesScreen(
                nickname: user.nickname,
              ),
            ),
          );
        },
      ),
    );
  }
}
