import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../models/habit.dart';

class DatabaseService {
  static Database? _database;
  static const String tableName = 'habits';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'habit_tracker.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            streak INTEGER NOT NULL,
            completedToday INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> insertHabit(Habit habit) async {
    final db = await database;
    habit.id = await db.insert(tableName, habit.toMap());
  }

  Future<List<Habit>> getHabits() async {
    final db = await database;
    final maps = await db.query(tableName);
    return List.generate(maps.length, (i) => Habit.fromMap(maps[i]));
  }

  Future<void> updateHabit(Habit habit) async {
    final db = await database;
    await db.update(
      tableName,
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }
}
