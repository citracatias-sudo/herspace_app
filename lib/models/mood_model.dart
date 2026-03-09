class MoodModel {
  final int? id;
  final String mood;
  final String note;

  MoodModel({this.id, required this.mood, required this.note});

  Map<String, dynamic> toMap() {
    return {"id": id, "mood": mood, "note": note};
  }

  factory MoodModel.fromMap(Map<String, dynamic> map) {
    return MoodModel(id: map["id"], mood: map["mood"], note: map["note"]);
  }
}
