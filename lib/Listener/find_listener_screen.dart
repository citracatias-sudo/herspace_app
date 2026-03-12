import 'package:flutter/material.dart';
import '../models/user_model.dart';

class FindListenerScreen extends StatelessWidget {
  final UserModel user;

  const FindListenerScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final listeners = ["Anna", "Maria", "Sophie", "Linda"];

    return Scaffold(
      appBar: AppBar(title: Text("Available Listeners")),
      body: ListView.builder(
        itemCount: listeners.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text(listeners[index]),
            subtitle: Text("Online"),
            trailing: ElevatedButton(
              child: Text("Talk"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          );
        },
      ),
    );
  }
}
