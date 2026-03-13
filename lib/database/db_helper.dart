import 'package:herspace_app/models/discussion_model.dart';
import '../models/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/mood_model.dart';
import '../models/chat_model.dart';

class DBHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();

    return openDatabase(
      join(dbPath, 'herspace.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE user(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          email TEXT,
          password TEXT,
          phone TEXT,
          role TEXT,
          nickname TEXT,
          avatar TEXT,
          isOnline INTEGER
        )
        ''');

        await db.execute('''
        CREATE TABLE mood(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          mood TEXT,
          date TEXT,
          note TEXT
        )
        ''');

        await db.execute('''
        CREATE TABLE chat(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          roomId TEXT,
          message TEXT,
          sender TEXT,
          time TEXT
        )
        ''');

        await db.execute('''
        CREATE TABLE sessions(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          roomId TEXT,
          duration INTEGER,
          rating INTEGER,
          report TEXT
        )
        ''');

        await db.execute('''
        CREATE TABLE discussion(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          content TEXT,
          author TEXT,
          topic TEXT,
          likes INTEGER
        )
        ''');

        await db.execute('''
        CREATE TABLE chat_rooms(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          roomId TEXT,
          speakerId INTEGER,
          listenerId INTEGER,
          createdAt TEXT
        )
        ''');
      },
    );
  }

  /// INIT DATABASE (dipakai semua function)
  static Future<Database> db() async {
    return await database;
  }

  /// REGISTER
  static Future<void> registerUser(UserModel user) async {
    final dbs = await db();
    await dbs.insert('user', user.toMap());
  }

  /// LOGIN
  static Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    final dbs = await db();

    final results = await dbs.query(
      "user",
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (results.isNotEmpty) {
      return UserModel.fromMap(results.first);
    }

    return null;
  }

  /// FORGOT PASSWORD
  static Future<bool> updatePassword(String email, String newPassword) async {
    final dbs = await db();

    int result = await dbs.update(
      'user',
      {'password': newPassword},
      where: 'email = ?',
      whereArgs: [email],
    );

    return result > 0;
  }

  /// INSERT MOOD
  static Future<void> insertMood(MoodModel mood) async {
    final dbs = await db();
    await dbs.insert("mood", mood.toMap());
  }

  /// GET MOODS
  static Future<List<MoodModel>> getMoods() async {
    final dbs = await db();
    final results = await dbs.query("mood");

    return results.map((e) => MoodModel.fromMap(e)).toList();
  }

  /// DELETE MOOD
  static Future<void> deleteMood(int id) async {
    final dbs = await db();
    await dbs.delete("mood", where: "id = ?", whereArgs: [id]);
  }

  /// INSERT MESSAGE
  static Future<void> insertMessage(ChatModel chat) async {
    final dbs = await db();
    await dbs.insert("chat", chat.toMap());
  }

  /// GET ALL MESSAGES
  static Future<List<ChatModel>> getMessages() async {
    final dbs = await db();
    final results = await dbs.query("chat");

    return results.map((e) => ChatModel.fromMap(e)).toList();
  }

  /// GET MESSAGE BY ROOM
  static Future<List<ChatModel>> getMessagesByRoom(String roomId) async {
    final dbs = await db();

    final results = await dbs.query(
      "chat",
      where: "roomId = ?",
      whereArgs: [roomId],
      orderBy: "id ASC",
    );

    return results.map((e) => ChatModel.fromMap(e)).toList();
  }

  /// GET LAST MESSAGE PER ROOM
  static Future<List<ChatModel>> getLastMessages() async {
    final dbs = await db();

    final results = await dbs.rawQuery('''
      SELECT * FROM chat
      WHERE id IN (
        SELECT MAX(id)
        FROM chat
        GROUP BY roomId
      )
    ''');

    return results.map((e) => ChatModel.fromMap(e)).toList();
  }

  /// DELETE MESSAGE
  static Future<void> deleteMessage(int id) async {
    final dbs = await db();
    await dbs.delete("chat", where: "id = ?", whereArgs: [id]);
  }

  /// UPDATE AVATAR
  static Future<void> updateAvatar(int id, String avatar) async {
    final dbs = await db();

    await dbs.update(
      "user",
      {"avatar": avatar},
      where: "id = ?",
      whereArgs: [id],
    );
  }

  /// UPDATE PROFILE
  static Future<int> updateUser(int id, String email, String phone) async {
    final dbs = await db();

    return await dbs.update(
      "user",
      {"email": email, "phone": phone},
      where: "id = ?",
      whereArgs: [id],
    );
  }

  /// UPDATE ROLE
  static Future<void> updateUserRole(int id, String role) async {
    final dbs = await db();

    await dbs.update("user", {"role": role}, where: "id = ?", whereArgs: [id]);
  }

  /// INSERT DISCUSSION
  static Future<void> insertDiscussion(DiscussionModel discussion) async {
    final dbs = await db();
    await dbs.insert("discussion", discussion.toMap());
  }

  /// GET DISCUSSIONS
  static Future<List<DiscussionModel>> getDiscussions() async {
    final dbs = await db();

    final results = await dbs.query("discussion", orderBy: "id DESC");

    return results.map((e) => DiscussionModel.fromMap(e)).toList();
  }

  /// LIKE DISCUSSION
  static Future<void> likeDiscussion(int id, int likes) async {
    final dbs = await db();

    await dbs.update(
      "discussion",
      {"likes": likes + 1},
      where: "id = ?",
      whereArgs: [id],
    );
  }

  /// GET ONLINE LISTENERS
  static Future<List<UserModel>> getOnlineListeners() async {
    final dbs = await db();

    final results = await dbs.query(
      "user",
      where: "role = ? AND isOnline = ?",
      whereArgs: ["listener", 1],
    );

    return results.map((e) => UserModel.fromMap(e)).toList();
  }

  /// CREATE CHAT ROOM
  static Future<String> createRoom(int speakerId, int listenerId) async {
    final dbs = await db();

    String roomId = "${speakerId}_$listenerId";

    await dbs.insert("chat_rooms", {
      "roomId": roomId,
      "speakerId": speakerId,
      "listenerId": listenerId,
      "createdAt": DateTime.now().toString(),
    });

    return roomId;
  }

  /// UPDATE ONLINE STATUS
  static Future<void> updateOnlineStatus(int id, bool status) async {
    final dbs = await db();

    await dbs.update(
      "user",
      {"isOnline": status ? 1 : 0},
      where: "id = ?",
      whereArgs: [id],
    );
  }
  //Chat Rooms Listener
  static Future<List<Map<String, dynamic>>> getListenerRooms(
    int listenerId,
  ) async {
    final dbs = await db();

    return await dbs.query(
      "chat_rooms",
      where: "listenerId = ?",
      whereArgs: [listenerId],
    );
  }
}
