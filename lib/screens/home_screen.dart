import 'package:flutter/material.dart';
import 'package:herspace_app/screens/profile_screen.dart';
import '../widgets/app_background.dart';
import '../widgets/soft_card.dart';
import '../models/user_model.dart';
import 'chat_screen.dart';
import 'mood_tracker_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  late final List<Widget> pages = [
    ChatScreen(),
    MoodTrackerScreen(),
    ProfileScreen(user: widget.user),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: pages[selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: "Chat",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.mood), label: "Mood"),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
