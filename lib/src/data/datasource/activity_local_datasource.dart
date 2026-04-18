import 'package:sqflite/sqflite.dart';

import 'package:academic_planner/src/core/database/tables/activity_table.dart';

import 'package:academic_planner/src/data/filters/activity_filter.dart';

class ActivityLocalDataSource {
  final Database db;

  ActivityLocalDataSource(this.db);

  Future<List<Map<String, dynamic>>> getAll({ActivityFilter? filter}) async {
    final whereClauses = <String>[];
    final whereArgs = <dynamic>[];

    if (filter != null) {
      if (filter.disciplineId != null) {
        whereClauses.add('disciplineId = ?');
        whereArgs.add(filter.disciplineId);
      }

      final statuses = filter.statuses;
      if (statuses != null && statuses.isNotEmpty) {
        final placeholders = List.filled(statuses.length, '?').join(', ');
        whereClauses.add('status IN ($placeholders)');
        whereArgs.addAll(statuses.map((s) => s.name));
      }

      if (filter.startDate != null) {
        whereClauses.add('dueDate >= ?');
        whereArgs.add(filter.startDate!.toIso8601String());
      }

      if (filter.endDate != null) {
        whereClauses.add('dueDate <= ?');
        whereArgs.add(filter.endDate!.toIso8601String());
      }

      if (filter.search != null && filter.search!.isNotEmpty) {
        whereClauses.add('title LIKE ?');
        whereArgs.add('%${filter.search}%');
      }
    }

    return db.query(
      ActivityTable.tableName,
      where: whereClauses.isEmpty ? null : whereClauses.join(' AND '),
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
    );
  }

  Future<int> count({ActivityFilter? filter}) async {
    final whereClauses = <String>[];
    final whereArgs = <dynamic>[];

    if (filter != null) {
      if (filter.disciplineId != null) {
        whereClauses.add('disciplineId = ?');
        whereArgs.add(filter.disciplineId);
      }

      final statuses = filter.statuses;
      if (statuses != null && statuses.isNotEmpty) {
        final placeholders = List.filled(statuses.length, '?').join(', ');
        whereClauses.add('status IN ($placeholders)');
        whereArgs.addAll(statuses.map((s) => s.name));
      }
    }

    final result = await db.rawQuery('''
    SELECT COUNT(*) as count
    FROM ${ActivityTable.tableName}
    ${whereClauses.isEmpty ? '' : 'WHERE ${whereClauses.join(' AND ')}'}
    ''', whereArgs);

    return Sqflite.firstIntValue(result) ?? 0;
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
