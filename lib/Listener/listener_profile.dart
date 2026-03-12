import 'package:flutter/material.dart';
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

                Column(
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
              ],
            ),

            SizedBox(height: 30),

            /// LISTENER SWITCH
            if (widget.user.role == "listener")
              Card(
                child: SwitchListTile(
                  title: Text("Available to Listen"),
                  subtitle: Text("Turn on to receive speaker requests"),
                  value: isOnline,
                  onChanged: (value) {
                    setState(() {
                      isOnline = value;
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
