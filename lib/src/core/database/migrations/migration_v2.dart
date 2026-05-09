import 'package:sqflite/sqflite.dart';

import 'package:academic_planner/src/core/database/migrations/migration.dart';
import 'package:academic_planner/src/core/database/tables/note_table.dart';

class MigrationV2 implements Migration {
  @override
  int get version => 2;

  @override
  Future<void> up(Database db) async {
    await db.execute(NoteTable.createTableQuery);
  }

  @override
  Future<void> down(Database db) async {
    await db.execute('DROP TABLE IF EXISTS ${NoteTable.tableName}');
  }
}
