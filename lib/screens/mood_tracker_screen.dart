import 'package:flutter/material.dart';
import 'package:herspace_app/decorations/app_colors.dart';
import '../database/db_helper.dart';
import '../models/mood_model.dart';
import 'package:intl/intl.dart';

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  TextEditingController noteController = TextEditingController();

  List<MoodModel> dataMood = [];

  String selectedMood = "Great";

  DateTime now = DateTime.now();

  List<Map<String, String>> moods = [
    {"emoji": "😊", "label": "Great"},
    {"emoji": "🙂", "label": "Good"},
    {"emoji": "😐", "label": "Okay"},
    {"emoji": "😢", "label": "Sad"},
    {"emoji": "😫", "label": "Stressed"},
  ];

  @override
  void initState() {
    super.initState();
    getDataMood();
  }

  Future<void> getDataMood() async {
    dataMood = await DBHelper.getMoods();
    setState(() {});
  }

  /// mencari emoji mood berdasarkan tanggal
  String getMoodEmojiForDay(int day) {
    for (var mood in dataMood) {
      DateTime moodDate = DateTime.parse(mood.date);

      if (moodDate.day == day &&
          moodDate.month == now.month &&
          moodDate.year == now.year) {
        return moods.firstWhere(
          (m) => m["label"] == mood.mood,
          orElse: () => {"emoji": ""},
        )["emoji"]!;
      }
    }

    return "";
  }

  @override
  Widget build(BuildContext context) {
    String monthYear = DateFormat('MMMM yyyy').format(now);

    return Scaffold(
      backgroundColor: Color(0xFFFFF6F9),

      appBar: AppBar(
        title: Text("Mood Tracker"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),

        child: Column(
          children: [
            /// CARD INPUT MOOD
            Container(
              padding: EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),

              child: Column(
                children: [
                  Text(
                    "How are you feeling today?",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),

                  SizedBox(height: 15),

                  /// EMOJI SELECTOR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: moods.map((mood) {
                      bool isSelected = selectedMood == mood["label"];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedMood = mood["label"]!;
                          });
                        },

                        child: Container(
                          padding: EdgeInsets.all(10),

                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.secondary.withOpacity(0.5)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: Column(
                            children: [
                              Text(
                                mood["emoji"]!,
                                style: TextStyle(fontSize: 26),
                              ),

                              SizedBox(height: 4),

                              Text(
                                mood["label"]!,
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 20),

                  /// NOTE FIELD
                  TextField(
                    controller: noteController,

                    decoration: InputDecoration(
                      hintText: "Add a note",
                      filled: true,
                      fillColor: Color(0xFFEAEAF2),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  SizedBox(height: 15),

                  /// SAVE BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 45,

                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      onPressed: () async {
                        if (noteController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Mind to share your feelings with us? 😯",
                              ),
                            ),
                          );
                          return;
                        }

                        String today = DateFormat(
                          'yyyy-MM-dd',
                        ).format(DateTime.now());

                        MoodModel mood = MoodModel(
                          mood: selectedMood,
                          note: noteController.text,
                          date: today,
                        );

                        await DBHelper.insertMood(mood);

                        noteController.clear();

                        await getDataMood();

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("Mood saved")));
                      },

                      child: Text(
                        "Save Mood",
                        style: TextStyle(color: AppColors.card),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            /// CALENDAR
            buildCalendar(monthYear),

            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Recent Entries",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 10),

            /// HISTORY LIST
            SizedBox(
              height: 250,

              child: dataMood.isEmpty
                  ? Center(
                      child: Text(
                        "No mood recorded yet",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: dataMood.length,

                      itemBuilder: (context, index) {
                        final mood = dataMood[index];

                        String emoji = moods.firstWhere(
                          (m) => m["label"] == mood.mood,
                          orElse: () => {"emoji": "🙂"},
                        )["emoji"]!;

                        return Container(
                          margin: EdgeInsets.only(bottom: 12),
                          padding: EdgeInsets.all(15),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 6),
                            ],
                          ),

                          child: Row(
                            children: [
                              /// EMOJI
                              Container(
                                padding: EdgeInsets.all(10),

                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12),
                                ),

                                child: Text(
                                  emoji,
                                  style: TextStyle(fontSize: 22),
                                ),
                              ),

                              SizedBox(width: 12),

                              /// TEXT
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      mood.mood,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),

                                    SizedBox(height: 2),

                                    Text(
                                      mood.note,
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),

                                    SizedBox(height: 2),

                                    Text(
                                      DateFormat(
                                        'dd MMM yyyy',
                                      ).format(DateTime.parse(mood.date)),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              /// DELETE
                              IconButton(
                                icon: Icon(Icons.delete_outline),

                                onPressed: () async {
                                  if (mood.id == null) return;

                                  await DBHelper.deleteMood(mood.id!);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Mood Deleted")),
                                  );

                                  await getDataMood();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// CALENDAR
  Widget buildCalendar(String monthYear) {
    List<String> days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

    int totalDays = DateTime(now.year, now.month + 1, 0).day;

    return Container(
      padding: EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),

      child: Column(
        children: [
          Text(
            monthYear,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: days.map((d) => Text(d)).toList(),
          ),

          SizedBox(height: 10),

          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.8,
            ),
            itemCount: totalDays,

            itemBuilder: (context, index) {
              int day = index + 1;

              String emoji = getMoodEmojiForDay(day);

              return Container(
                margin: EdgeInsets.all(4),

                decoration: BoxDecoration(
                  color: emoji.isNotEmpty
                      ? AppColors.secondary.withOpacity(0.3)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),

                child: Center(
                  child: emoji.isNotEmpty
                      ? Text(emoji, style: TextStyle(fontSize: 22))
                      : Text(
                          "$day",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
