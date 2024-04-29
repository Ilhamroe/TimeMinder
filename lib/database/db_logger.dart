import 'package:sqflite/sqflite.dart' as sql;

class SQLLogger {
  static Future<void> createTable(sql.Database database) async {
    await database.execute('''CREATE TABLE IF NOT EXISTS data (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        length INTEGER NOT NULL,
        passed INTEGER NOT NULL,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )''');
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase("database_name.db", version: 1,
        onCreate: (sql.Database database, int version) async {
          await createTable(database);
        });
  }

  static Future<int> createData(String title, String description, int length,
      int passed) async {
    final db = await SQLLogger.db();

    final data = {
      'title': title,
      'description': description,
      'length': length,
      'passed': passed
    };
    final id = await db.insert('data', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await SQLLogger.db();
    return db.query('data', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getSingleData(int id) async {
    final db = await SQLLogger.db();
    return db.query('data', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateData(int id, String title, String description,
      int length, int passed) async {
    final db = await SQLLogger.db();
    final data = {
      'title': title,
      'description': description,
      'length': length,
      'passed': passed,
      'createdAt': DateTime.now().toString()
    };
    final result =
    await db.update('data', data, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  static Future<void> deleteData(int id) async {
    final db = await SQLLogger.db();
    try {
      await db.delete('data', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print("Error deleting data: $e");
    }
  }
}
