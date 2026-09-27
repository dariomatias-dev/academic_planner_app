import 'package:academic_planner/src/core/database/tables/note_table.dart';
import 'package:sqflite/sqflite.dart';

class NoteLocalDataSource {
  NoteLocalDataSource(this.db);

  final Database db;

  Future<void> insert(Map<String, dynamic> data) async {
    await db.insert(NoteTable.tableName, data);
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    return db.query(NoteTable.tableName, orderBy: 'updatedAt DESC');
  }

  Future<Map<String, dynamic>?> getById(String id) async {
    final result = await db.query(
      NoteTable.tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    return result.isEmpty ? null : result.first;
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    await db.update(
      NoteTable.tableName,
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> delete(String id) async {
    await db.delete(NoteTable.tableName, where: 'id = ?', whereArgs: [id]);
  }
}
