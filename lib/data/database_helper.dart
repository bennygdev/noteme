import 'data_classes.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class DatabaseHelper {
  Future<Database> initializeDb() async {
    String path = await getDatabasesPath();

    return openDatabase(join(path, "bennygoh_notion.db"), version:1,
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE IF NOT EXISTS Note("
              "id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"
              "dateEpochMS INTEGER NOT NULL,"
              "title TEXT NOT NULL,"
              "img TEXT NULL,"
              "description TEXT NOT NULL"
              ")"
          );

          await db.execute("CREATE TABLE IF NOT EXISTS Comment("
              "id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"
              "noteId INTEGER NOT NULL,"
              "dateEpochMS INTEGER NOT NULL,"
              "comment TEXT NOT NULL"
              ")"
          );
        }
    );
  }

  // add note
  Future<void> insertNote(Note note) async {
    final Database db = await initializeDb();
    await db.insert(
      'Note',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // retrieve all note
  Future<List<Note>> retrieveNotes() async {
    final Database db = await initializeDb();
    final List<Map<String, dynamic>> queryResult = await db.query("Note");
    return queryResult.map((e) => Note.fromMap(e)).toList();
  }

  // confirm later

  // modify note
  // ...

  // delete note
  Future<void> deleteNote(int id) async {
    final Database db = await initializeDb();
    await db.delete("Note", where: "id = ?", whereArgs: [id]);
  }

  // retrieve all comment
  Future<List<Comment>> retrieveComments(int mealId) async{
    final Database db = await initializeDb();
    final List<Map<String, dynamic>> queryResult =
    await db.query("Comment", where: "mealId = ?", whereArgs: [mealId]);
    return queryResult.map((e) => Comment.fromMap(e)).toList();
  }

  // add comment
  Future<int> insertComment(Comment comment) async{
    int result = 0;
    final Database db = await initializeDb();
    result = await db.insert("Comment", comment.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  // modify comment
  // ...

  // delete comment
  Future<void> deleteComments(int mealId) async{
    final Database db = await initializeDb();
    await db.delete("Comment", where: "mealId = ?", whereArgs: [mealId]);
  }
}