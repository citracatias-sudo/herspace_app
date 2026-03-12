import 'package:herspace_app/models/discussion_model.dart';

import '../models/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/mood_model.dart';
import '../models/chat_model.dart';

class DBHelper {
  static Future<Database> db() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'my_app.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE user (id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, password TEXT, phone TEXT, role TEXT, nickname TEXT, avatar TEXT, isOnline INTEGER)',
        );

        await db.execute(
          'CREATE TABLE mood (id INTEGER PRIMARY KEY AUTOINCREMENT, mood TEXT, date TEXT, note TEXT)',
        );
        await db.execute(
          'CREATE TABLE chat(id INTEGER PRIMARY KEY AUTOINCREMENT, roomId TEXT, message TEXT, sender TEXT, time TEXT)',
        );

        await db.execute(
          'CREATE TABLE sessions(id INTEGER PRIMARY KEY AUTOINCREMENT, roomId TEXT, duration INTEGER, rating INTEGER, report TEXT)',
        );
        await db.execute('''CREATE TABLE discussion(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT, author TEXT, topic TEXT, likes INTEGER
)
''');
      },
      version: 1,
    );
  }

  //register
  static Future<void> registerUser(UserModel user) async {
    final dbs = await db();

    await dbs.insert('user', user.toMap());
    print(user.toMap());
  }

  //login
  static Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    final dbs = await db();
    final List<Map<String, dynamic>> results = await dbs.query(
      "user",
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (results.isNotEmpty) {
      return UserModel.fromMap(results.first);
    }
    return null;
  }

  //Insert Mood
  static Future<void> insertMood(MoodModel mood) async {
    final dbs = await db();

    await dbs.insert("mood", mood.toMap());
  }

  //Get Mood
  static Future<List<MoodModel>> getMoods() async {
    final dbs = await db();

    final List<Map<String, dynamic>> results = await dbs.query("mood");

    return results.map((e) => MoodModel.fromMap(e)).toList();
  }

  //Delete
  static Future<void> deleteMood(int id) async {
    final dbs = await db();

    await dbs.delete("mood", where: "id = ?", whereArgs: [id]);
  }

  //chat
  static Future<void> insertMessage(ChatModel chat) async {
    final dbs = await db();

    await dbs.insert("chat", chat.toMap());
  }

  //Get Message
  static Future<List<ChatModel>> getMessages() async {
    final dbs = await db();

    final List<Map<String, dynamic>> results = await dbs.query("chat");

    return results.map((e) => ChatModel.fromMap(e)).toList();
  }

  // Get Messages by Room
  static Future<List<ChatModel>> getMessagesByRoom(String roomId) async {
    final dbs = await db();

    final List<Map<String, dynamic>> results = await dbs.query(
      "chat",
      where: "roomId = ?",
      whereArgs: [roomId],
      orderBy: "id ASC",
    );

    return results.map((e) => ChatModel.fromMap(e)).toList();
  }

  static Future<List<ChatModel>> getLastMessages() async {
    final dbs = await db();

    final List<Map<String, dynamic>> results = await dbs.rawQuery('''
    SELECT * FROM chat
    WHERE id IN (
      SELECT MAX(id)
      FROM chat
      GROUP BY roomId
    )
  ''');

    return results.map((e) => ChatModel.fromMap(e)).toList();
  }
  //mengembalikan list chatModel

  //Delete Message
  static Future<void> deleteMessage(int id) async {
    final dbs = await db();

    await dbs.delete("chat", where: "id = ?", whereArgs: [id]);
  }

  // avatar
  static Future<void> updateAvatar(int id, String avatar) async {
    final dbs = await db();

    await dbs.update(
      "user",
      {"avatar": avatar},
      where: "id = ?",
      whereArgs: [id],
    );
  }

  //Edit Profile
  static Future<int> updateUser(int id, String email, String phone) async {
    final dbs = await db();

    return await dbs.update(
      "user",
      {"email": email, "phone": phone},
      where: "id = ?",
      whereArgs: [id],
    );
  }

  //User Role
  static Future<void> updateUserRole(int id, String role) async {
    final dbs = await db();

    await dbs.update("user", {"role": role}, where: "id = ?", whereArgs: [id]);
  }

//Insert Discussion
  static Future<void> insertDiscussion(DiscussionModel discussion) async {
  final dbs = await db();
  await dbs.insert("discussion", discussion.toMap());
}
//Get Discussion
  static Future<List<DiscussionModel>> getDiscussions() async {
  final dbs = await db();

  final results = await dbs.query(
    "discussion",
    orderBy: "id DESC",
  );

  return results.map((e) => DiscussionModel.fromMap(e)).toList();
}
//Like Post
  static Future<void> likeDiscussion(int id, int likes) async {
  final dbs = await db();

  await dbs.update(
    "discussion",
    {"likes": likes + 1},
    where: "id = ?",
    whereArgs: [id],
  );
  
} 
//Get Online User
static Future<List<UserModel>> getOnlineListeners() async {
  final dbs = await db();

  final results = await dbs.query(
    "user",
    where: "role = ? AND isOnline = ?",
    whereArgs: ["listener", 1],
  );

  return results.map((e) => UserModel.fromMap(e)).toList();
}

}
