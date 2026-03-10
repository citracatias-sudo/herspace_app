import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/mood_model.dart';

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  final TextEditingController noteController = TextEditingController();

  late List<MoodModel> dataMood = [];
  String selectedMood = "Happy";

  //Panggil Data Mood
  @override
  void initState() {
    super.initState();
    getDataMood();
  }

  Future<void> getDataMood() async {
    dataMood = await DBHelper.getMoods();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mood Tracker")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedMood,
              items: ["Happy", "Sad", "Anxious", "Angry"]
                  .map(
                    (mood) => DropdownMenuItem(value: mood, child: Text(mood)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedMood = value!;
                });
              },
            ),

            SizedBox(height: 20),

            TextField(
              controller: noteController,
              decoration: InputDecoration(
                labelText: "How do you feel today?",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                if (noteController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Mind to share your feelings with us? 😯"),
                    ),
                  );
                  return;
                }

                final mood = MoodModel(
                  mood: selectedMood,
                  note: noteController.text,
                );

                await DBHelper.insertMood(mood);
                noteController.clear(); // reset textfield
                selectedMood = "Happy"; // reset dropdown
                await getDataMood(); //langsung tampil mood

                setState(() {});

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Mood saved")));
              },
              child: Text("Save Mood"),
            ),
            SizedBox(height: 20),
            Expanded(
              child: dataMood.isEmpty
                  ? Center(
                      child: Text(
                        'No mood recorded yet',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: dataMood.length,
                      itemBuilder: (context, index) {
                        final mood = dataMood[index];

                        return ListTile(
                          title: Text(mood.mood),
                          subtitle: Text(mood.note),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  if (mood.id == null) return;

                                  await DBHelper.deleteMood(mood.id!);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Mood Deleted")),
                                  );
                                  await getDataMood();
                                },
                                icon: Icon(Icons.delete),
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
}
