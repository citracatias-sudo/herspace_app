import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../database/db_helper.dart';
import '../models/user_model.dart';
import '../screens/chat_screen.dart';

class FindListenerScreen extends StatefulWidget {
  final UserModel user;

  const FindListenerScreen({super.key, required this.user});

  @override
  State<FindListenerScreen> createState() => _FindListenerScreenState();
}

class _FindListenerScreenState extends State<FindListenerScreen> {

  List<UserModel> listeners = [];

  @override
  void initState() {
    super.initState();
    loadListeners();
  }

  Future<void> loadListeners() async {
    listeners = await DBHelper.getOnlineListeners();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Available Listeners"),
      ),

      body: listeners.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
              "assets/lottie_animations/empty box3.json",
              width: 220,
            ),

            SizedBox(height: 10),

            Text(
              "No listener online right now",
              style: TextStyle(fontSize: 16),
            ),

                ],
              )
            )
          : ListView.builder(
              itemCount: listeners.length,
              itemBuilder: (context, index) {

                final listener = listeners[index];

                return ListTile(
                  leading: CircleAvatar(
                    child: Text(listener.nickname[0]),
                  ),

                  title: Text(listener.nickname),

                  subtitle: Text("Online"),

                  trailing: ElevatedButton(
                    child: Text("Talk"),

                    onPressed: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            nickname: widget.user.nickname,
                            roomId: "room_${listener.id}",
                            listenerName: listener.nickname,
                          ),
                        ),
                      );

                    },
                  ),
                );
              },
            ),
    );
  }
}