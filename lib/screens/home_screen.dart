import 'package:flutter/material.dart';
import 'package:herspace_app/decorations/app_colors.dart';
import 'package:herspace_app/screens/call_screen.dart';
import 'package:herspace_app/screens/profile_screen.dart';
import '../models/user_model.dart';
import 'chat_screen.dart';
import 'mood_tracker_screen.dart';
import 'home_dashboard_screen.dart';
import 'articles_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  late final List<Widget> pages = [
    HomeDashboardScreen(user: widget.user),
    ChatScreen(nickname: widget.user.nickname),
    ProfileScreen(user: widget.user),
    CallScreen(),
    MoodTrackerScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_rounded),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(Icons.call_outlined),

                Positioned(
                  right: -6,
                  top: -4,
                  child: Icon(
                    Icons.workspace_premium,
                    size: 14,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
            label: "Call",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: "Mood",
          ),
        ],
      ),
    );
  }
}
