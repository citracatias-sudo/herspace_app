import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/discussion_model.dart';
import '../decorations/app_colors.dart';

class CommunityScreen extends StatefulWidget {
  final String nickname;

  const CommunityScreen({super.key, required this.nickname});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {

  List<DiscussionModel> discussions = [];

  @override
  void initState() {
    super.initState();
    loadDiscussions();
  }

  Future<void> loadDiscussions() async {
    discussions = await DBHelper.getDiscussions();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: Text("Community"),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondary,
        child: Icon(Icons.add),

        onPressed: () {
          showCreatePost();
        },
      ),

      body: discussions.isEmpty
    ? Center(
        child: Text("No discussions yet"),
      )
    : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: discussions.length,

        itemBuilder: (context, index) {

          final post = discussions[index];

          return Container(
            margin: EdgeInsets.only(bottom: 14),

            padding: EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 6)
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  post.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  post.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 12),

                Row(
                  children: [

                    Text(
                      post.author,
                      style: TextStyle(color: Colors.grey),
                    ),

                    Spacer(),

                    IconButton(
                      icon: Icon(Icons.favorite_border),

                      onPressed: () async {

                        await DBHelper.likeDiscussion(
                          post.id!,
                          post.likes,
                        );

                        loadDiscussions();
                      },
                    ),

                    Text(post.likes.toString())
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void showCreatePost() {

    TextEditingController title = TextEditingController();
    TextEditingController content = TextEditingController();

    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(

          title: Text("Create Post"),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [

              TextField(
                controller: title,
                decoration: InputDecoration(
                  hintText: "Title",
                ),
              ),

              SizedBox(height: 10),

              TextField(
                controller: content,
                decoration: InputDecoration(
                  hintText: "Share your thoughts",
                ),
              ),
            ],
          ),

          actions: [

            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            ElevatedButton(
              child: Text("Post"),

              onPressed: () async {

                final post = DiscussionModel(
                  title: title.text,
                  content: content.text,
                  author: widget.nickname,
                  topic: "general",
                  likes: 0,
                );

                await DBHelper.insertDiscussion(post);

                Navigator.pop(context);

                loadDiscussions();
              },
            )
          ],
        );
      },
    );
  }
}