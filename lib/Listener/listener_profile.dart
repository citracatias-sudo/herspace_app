import 'package:flutter/material.dart';
import 'package:herspace_app/database/db_helper.dart';
import 'package:herspace_app/screens/login_screen.dart';
import '../models/user_model.dart';

class ListenerProfileHp extends StatefulWidget {
  final UserModel user;

  const ListenerProfileHp({super.key, required this.user});

  @override
  State<ListenerProfileHp> createState() => _ListenerProfileHpState();
}

class _ListenerProfileHpState extends State<ListenerProfileHp> {
  bool isOnline = false;
  @override
  void initState() {
    super.initState();

    isOnline = widget.user.isOnline;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// USER INFO
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  child: Text(widget.user.nickname[0].toUpperCase()),
                ),

                SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.nickname,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(widget.user.role),
                    ],
                  ),
                ),

                /// LOGOUT BUTTON
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

            SizedBox(height: 30),

            /// LISTENER SWITCH
            if (widget.user.role.toLowerCase() == "listener")
              Card(
                child: SwitchListTile(
                  title: Text("Available to Listen"),
                  subtitle: Text("Turn on to receive speaker requests"),
                  value: isOnline,
                  onChanged: (value) async {
                    setState(() {
                      isOnline = value;
                    });

                    await DBHelper.updateOnlineStatus(widget.user.id!, value);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
