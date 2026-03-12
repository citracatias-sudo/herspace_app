class SessionModel {
  final int? id;
  final String roomId;
  final int duration;
  final int rating;
  final String report;

  SessionModel({
    this.id,
    required this.roomId,
    required this.duration,
    required this.rating,
    required this.report,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "roomId": roomId,
      "duration": duration,
      "rating": rating,
      "report": report,
    };
  }
}
