import 'package:sqflite/sqflite.dart';

import 'package:academic_planner/src/core/database/tables/activity_table.dart';

class ActivityLocalDataSource {
  final Database db;

  ActivityLocalDataSource(this.db);

  Future<List<Map<String, dynamic>>> getAll() async {
    return db.query(ActivityTable.tableName);
  }

  Future<Map<String, dynamic>?> getById(String id) async {
    final result = await db.query(
      ActivityTable.tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return result.first;
  }

  Future<void> insert(Map<String, dynamic> data) async {
    await db.insert(ActivityTable.tableName, data);
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    await db.update(
      ActivityTable.tableName,
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> delete(String id) async {
    await db.delete(ActivityTable.tableName, where: 'id = ?', whereArgs: [id]);
  }
}
