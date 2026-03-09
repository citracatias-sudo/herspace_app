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

  String selectedMood = "Happy";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mood Tracker")),
      body: Padding(
        padding: const EdgeInsets.all(20),
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

            const SizedBox(height: 20),

            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: "How do you feel today?",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final mood = MoodModel(
                  mood: selectedMood,
                  note: noteController.text,
                );

                await DBHelper.insertMood(mood);

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Mood saved")));
              },
              child: const Text("Save Mood"),
            ),
          ],
        ),
      ),
    );
  }
}
