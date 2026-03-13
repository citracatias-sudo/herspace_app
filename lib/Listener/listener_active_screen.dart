import 'package:flutter/material.dart';
import 'package:herspace_app/database/db_helper.dart';
import 'package:herspace_app/screens/messages_screen.dart';
import '../models/user_model.dart';

class ActiveListenersScreen extends StatelessWidget {
  final UserModel speaker;

  const ActiveListenersScreen({super.key, required this.speaker});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Active Listeners")),

      body: FutureBuilder(
        future: DBHelper.getOnlineListeners(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final listeners = snapshot.data as List<UserModel>;

          if (listeners.isEmpty) {
            return Center(child: Text("No listener available right now"));
          }

          return ListView.builder(
            itemCount: listeners.length,

            itemBuilder: (context, index) {
              final listener = listeners[index];

              return ListTile(
                leading: CircleAvatar(
                  child: Text(listener.nickname[0].toUpperCase()),
                ),

                title: Text(listener.nickname),

                trailing: Icon(Icons.arrow_forward_ios),

                onTap: () async {
                  String roomId = "${speaker.id}_${listener.id}";

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MessagesScreen(
                        roomId: roomId,
                        nickname: listener.nickname,
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
