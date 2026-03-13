import 'dart:nativewrappers/_internal/vm/lib/ffi_patch.dart';

import 'package:flutter/material.dart';
import 'package:herspace_app/Listener/listener_active_screen.dart';
import 'package:herspace_app/database/db_helper.dart';
import 'package:herspace_app/decorations/app_colors.dart';
import 'package:herspace_app/screens/articles_screen.dart';
import 'package:herspace_app/screens/community_scree.dart';
import '../models/user_model.dart';
import '../widgets/article_card.dart';

class HomeDashboardScreen extends StatelessWidget {
  final UserModel user;

  HomeDashboardScreen({super.key, required this.user});

  final List<Map<String, String>> articles = [
    {
      "title": "The Power of Daily Meditation",
      "time": "5 min read",
      "image": "https://images.unsplash.com/photo-1506126613408-eca07ce68773",
    },
    {
      "title": "Building Self Confidence",
      "time": "4 min read",
      "image": "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e",
    },
    {
      "title": "Managing Stress",
      "time": "6 min read",
      "image": "https://images.unsplash.com/photo-1499209974431-9dddcece7f88",
    },
  ];

  final List<String> topics = [
    "All",
    "Career",
    "Wellness",
    "Mental Health",
    "Relationships",
    "Self Love",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(20),
          physics: BouncingScrollPhysics(),

          children: [
            /// HEADER
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    user.nickname[0].toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                SizedBox(width: 12),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi ${user.nickname}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    Text(
                      user.role.toUpperCase(),
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),

                Spacer(),

                Icon(Icons.notifications_none, color: AppColors.textPrimary),
              ],
            ),

            SizedBox(height: 24),

            /// SEARCH
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                  hintText: "Search discussions...",
                ),
              ),
            ),

            SizedBox(height: 20),

            /// COMMUNITY CARD
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.secondary, AppColors.primary],
                ),
                borderRadius: BorderRadius.circular(18),
              ),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ICON
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.forum, color: Colors.white, size: 26),
                  ),

                  SizedBox(width: 14),

                  /// TEXT
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Community Q&A",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            Spacer(),

                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CommunityScreen(
                                      nickname: user.nickname,
                                    ),
                                  ),
                                );
                              },

                              child: Row(
                                children: [
                                  Text(
                                    "See more",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 6),

                        Text(
                          "Ask questions, share knowledge, support each other",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 18),

            /// TALK TO LISTENER
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ActiveListenersScreen(speaker: user),
                  ),
                );
              },

              child: Container(
                padding: EdgeInsets.all(20),

                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.secondary, AppColors.primary],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),

                child: Row(
                  children: [
                    Icon(Icons.support_agent, color: Colors.white, size: 30),

                    SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Talk to a Listener",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 4),

                          Text(
                            "Find someone who will listen to you",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            /// ACTIVE LISTENERS
            FutureBuilder(
              future: DBHelper.getOnlineListeners(),

              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData) {
                  return SizedBox();
                }

                final listeners = snapshot.data as List<UserModel>;

                if (listeners.isEmpty) {
                  return Text(
                    "No listener available right now",
                    style: TextStyle(color: AppColors.textSecondary),
                  );
                }

                SizedBox(height: 20);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Active Listeners",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    SizedBox(height: 20),

                    SizedBox(
                      height: 70,

                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: listeners.length,

                        itemBuilder: (context, index) {
                          final listener = listeners[index];

                          return Container(
                            margin: EdgeInsets.only(right: 12),

                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: AppColors.primary,
                                  child: Text(
                                    listener.nickname[0].toUpperCase(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),

                                SizedBox(height: 4),

                                Text(
                                  listener.nickname,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 20),
                  ],
                );
              },
            ),
           

            /// TOPICS
            SizedBox(
              height: 40,

              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: topics.length,

                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: 10),

                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),

                    decoration: BoxDecoration(
                      color: index == 0 ? AppColors.secondary : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Text(
                      topics[index],
                      style: TextStyle(
                        color: index == 0
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 20),

            /// ARTICLES
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Recommended for You", style: TextStyle(fontSize: 20)),
              
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ArticlesScreen()),
                    );
                  },
                  child: Text("See all"),
                ),
              ],
            ),

            SizedBox(height: 12),

            SizedBox(
              height: 220,

              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: articles.length,

                itemBuilder: (context, index) {
                  var article = articles[index];

                  return Container(
                    width: 200,
                    margin: EdgeInsets.only(right: 14),

                    child: ArticleCard(
                      title: article["title"]!,
                      time: article["time"]!,
                      image: article["image"]!,
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
