// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChatModel {
  final int? id;
  final String message;
  final String roomId;
  final String sender;
  ChatModel({this.id, required this.message, required this.sender, required this.roomId});

  ChatModel copyWith({int? id, String? message, String? sender}) {
    return ChatModel(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      message: message ?? this.message,
      sender: sender ?? this.sender,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'roomId': roomId,
      'message': message,
      'sender': sender,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'] != null ? map["id"] as int : null,
      roomId: map['roomId'],
      message: (map["message"] ?? '') as String,
      sender: (map["sender"] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ChatModel(id: $id, message: $message, sender: $sender)';

  @override
  bool operator ==(covariant ChatModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.message == message && other.sender == sender;
  }

  @override
  int get hashCode => id.hashCode ^ message.hashCode ^ sender.hashCode;
}
