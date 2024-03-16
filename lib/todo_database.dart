
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:notes_app/models/todo.dart';

class TodoDatabase {
  late Database db;

  Future open() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'todo-database.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE IF NOT EXISTS todos(id INTEGER PRIMARY KEY, content TEXT)');
      },
    );
  }

  Future<List<Todo>> search() async {
    final List<Map<String, Object?>> todoMaps = await db.query('todos');
    return [
      for (final {
            'id': id as int,
            'content': content as String,
          } in todoMaps)
        Todo(id, content),
    ];
  }

  Future insert(Todo todo) async {
    await db.insert(
      'todos',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future update(Todo todo) async {
    await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future delete(Todo todo) async {
    await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }
}
