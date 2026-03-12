import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class DiscussionModel {
  final int? id;
  final String title;
  final String content;
  final String author;
  final String topic;
  final int likes;
  DiscussionModel({
    this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.topic,
    required this.likes,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'content': content,
      'author': author,
      'topic': topic,
      'likes': likes,
    };
  }

  factory DiscussionModel.fromMap(Map<String, dynamic> map) {
    return DiscussionModel(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      author: map['author'],
      topic: map['topic'],
      likes: map['likes'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DiscussionModel.fromJson(String source) => DiscussionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
