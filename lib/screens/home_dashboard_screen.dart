import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.all(20),
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
                    user.nickname,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text("Member"),
                ],
              ),

              Spacer(),

              TextButton(onPressed: () {}, child: Text("Logout")),
            ],
          ),

          SizedBox(height: 30),

          /// QUICK ACTION TITLE
          Text(
            "Quick Actions",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 12),

          /// COMMUNITY CHAT
          buildFeatureCard(
            icon: Icons.people_outline,
            title: "Community Chat",
            subtitle: "Connect with amazing women in our community",
          ),

          SizedBox(height: 16),

          /// DAILY INSPIRATION → ARTICLES
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ArticlesScreen()),
              );
            },
            child: buildFeatureCard(
              icon: Icons.auto_awesome_outlined,
              title: "Daily Inspiration",
              subtitle: "Read articles to inspire your journey",
            ),
          ),

          SizedBox(height: 30),

          /// ARTICLE TITLE
          Text(
            "Recommended for You",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 12),

          /// ARTICLE LIST
          Column(
            children: articles.map((article) {
              return Padding(
                padding: EdgeInsets.only(bottom: 16),

                child: ArticleCard(
                  title: article["title"]!,
                  time: article["time"]!,
                  image: article["image"]!,
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12)],
      ),

      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.secondary,
            child: Icon(icon, color: Colors.white),
          ),

          SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),

                SizedBox(height: 4),

                Text(subtitle, style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
