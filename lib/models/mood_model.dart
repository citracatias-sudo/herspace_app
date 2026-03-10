class MoodModel {
  final int? id;
  final String mood;
  final String note;
  final String date;

  MoodModel({
    this.id,
    required this.mood,
    required this.note,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {"id": id, "mood": mood, "note": note, "date": date};
  }

  factory MoodModel.fromMap(Map<String, dynamic> map) {
    return MoodModel(
      id: map["id"],
      mood: map["mood"],
      note: map["note"],
      date: map["date"],
    );
  }
}
