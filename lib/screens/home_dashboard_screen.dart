import 'package:flutter/material.dart';
import 'package:herspace_app/Listener/find_listener_scree.dart';
import 'package:herspace_app/decorations/app_colors.dart';
import 'package:herspace_app/screens/articles_screen.dart';
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

            /// TALK TO LISTENER CARD
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FindListenerScreen(user: user),
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

            SizedBox(height: 28),

            /// COMMUNITY TITLE
            Text(
              "Community Q&A",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            SizedBox(height: 4),

            Text(
              "Ask questions, share knowledge, support each other",
              style: TextStyle(color: AppColors.textSecondary),
            ),

            SizedBox(height: 18),

            /// TOPIC CHIPS
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

            /// DISCUSSION CARD
            buildDiscussionCard(),

            SizedBox(height: 14),

            buildDiscussionCard(),

            SizedBox(height: 30),

            /// ARTICLES TITLE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recommended for You",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ArticlesScreen()),
                    );
                  },
                  child: Text("See all"),
                ),
              ],
            ),

            SizedBox(height: 12),

            /// ARTICLE HORIZONTAL LIST
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

  Widget buildDiscussionCard() {
    return Container(
      padding: EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.secondary,
                child: Text("S", style: TextStyle(color: Colors.white)),
              ),

              SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sarah J.",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  Text(
                    "2h ago",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),

              Spacer(),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),

                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(10),
                ),

                child: Text(
                  "Career",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          Text(
            "How do you manage work-life balance as a working mom?",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 6),

          Text(
            "I struggle with finding time for myself while managing work and family...",
            style: TextStyle(color: AppColors.textSecondary),
          ),

          SizedBox(height: 14),

          Row(
            children: [
              Icon(Icons.thumb_up_alt_outlined, size: 18),

              SizedBox(width: 6),

              Text("24"),

              SizedBox(width: 16),

              Icon(Icons.chat_bubble_outline, size: 18),

              SizedBox(width: 6),

              Text("12 answers"),
            ],
          ),
        ],
      ),
    );
  }
}
