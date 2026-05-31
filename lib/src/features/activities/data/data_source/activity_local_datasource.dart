import 'package:sqflite/sqflite.dart';

import 'package:academic_planner/src/core/database/tables/activity_table.dart';
import 'package:academic_planner/src/core/domain/entities/pagination.dart';

import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_sort_order.dart';

class ActivityLocalDataSource {
  final Database db;

  ActivityLocalDataSource(this.db);

  (String? where, List<Object?>? args) _buildWhere(ActivityFilter? filter) {
    final whereClauses = <String>[];
    final whereArgs = <Object?>[];

    if (filter != null) {
      if (filter.disciplineId != null) {
        whereClauses.add('disciplineId = ?');
        whereArgs.add(filter.disciplineId);
      }

      if (filter.statuses != null && filter.statuses!.isNotEmpty) {
        final placeholders = List.filled(
          filter.statuses!.length,
          '?',
        ).join(', ');

        whereClauses.add('status IN ($placeholders)');
        whereArgs.addAll(filter.statuses!.map((s) => s.name));
      }

      if (filter.startDate != null) {
        whereClauses.add('dueDate >= ?');
        whereArgs.add(filter.startDate!.toIso8601String());
      }

      if (filter.endDate != null) {
        whereClauses.add('dueDate <= ?');
        whereArgs.add(filter.endDate!.toIso8601String());
      }

      if (filter.dueAfter != null) {
        whereClauses.add('dueDate >= ?');
        whereArgs.add(filter.dueAfter!.toIso8601String());
      }

      if (filter.dueBefore != null) {
        whereClauses.add('dueDate <= ?');
        whereArgs.add(filter.dueBefore!.toIso8601String());
      }

      if (filter.search != null && filter.search!.isNotEmpty) {
        whereClauses.add('title LIKE ?');
        whereArgs.add('%${filter.search}%');
      }

      if (filter.category != null && filter.category!.isNotEmpty) {
        whereClauses.add('category = ?');
        whereArgs.add(filter.category);
      }

      if (filter.tags != null && filter.tags!.isNotEmpty) {
        for (final tag in filter.tags!) {
          whereClauses.add('tags LIKE ?');
          whereArgs.add('%"$tag"%');
        }
      }
    }

    return (
      whereClauses.isEmpty ? null : whereClauses.join(' AND '),
      whereArgs.isEmpty ? null : whereArgs,
    );
  }

  Future<void> insert(Map<String, dynamic> data) async {
    await db.insert(ActivityTable.tableName, data);
  }

  String? _buildOrderBy(ActivityFilter? filter) {
    if (filter?.sortField == null) return null;

    final order = filter!.sortOrder ?? ActivitySortOrder.desc;

    return '${filter.sortField!.column} ${order.name.toUpperCase()}';
  }

  Future<List<Map<String, dynamic>>> getAll({
    ActivityFilter? filter,
    Pagination? pagination,
  }) async {
    final (String? where, List<Object?>? args) = _buildWhere(filter);

    return await db.query(
      ActivityTable.tableName,
      where: where,
      whereArgs: args,
      orderBy: _buildOrderBy(filter),
      limit: pagination?.limit,
      offset: pagination != null ? (pagination.page * pagination.limit) : null,
    );
  }

  Future<int> count({ActivityFilter? filter}) async {
    final (String? where, List<Object?>? args) = _buildWhere(filter);

    final result = await db.rawQuery('''
      SELECT COUNT(*) as count
      FROM ${ActivityTable.tableName}
      ${where != null ? 'WHERE $where' : ''}
    ''', args);

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<Map<String, dynamic>?> getById(String id) async {
    final result = await db.query(
      ActivityTable.tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    return result.isEmpty ? null : result.first;
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
