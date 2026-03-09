import '../models/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/mood_model.dart';

class DBHelper {
  static Future<Database> db() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'my_app.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE user (id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, password TEXT, phone TEXT, role TEXT)',
        );

        await db.execute(
          'CREATE TABLE mood (id INTEGER PRIMARY KEY AUTOINCREMENT, mood TEXT, note TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<void> registerUser(UserModel user) async {
    final dbs = await db();

    await dbs.insert('user', user.toMap());
    print(user.toMap());
  }

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

  static Future<void> insertMood(MoodModel mood) async {
    final dbs = await db();

    await dbs.insert("mood", mood.toMap());
  }
}
