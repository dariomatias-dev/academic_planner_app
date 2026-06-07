import 'package:academic_planner/src/core/database/migrations/migration.dart';
import 'package:academic_planner/src/core/database/tables/activity_table.dart';
import 'package:sqflite/sqflite.dart';

class MigrationV1 implements Migration {
  @override
  int get version => 1;

  @override
  Future<void> up(Database db) async {
    await db.execute(ActivityTable.createTableQuery);
  }

  @override
  Future<void> down(Database db) async {
    await db.execute('DROP TABLE IF EXISTS ${ActivityTable.tableName}');
  }
}
