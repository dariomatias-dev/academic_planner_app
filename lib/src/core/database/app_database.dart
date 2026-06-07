import 'package:academic_planner/src/core/database/migrations/migration.dart';
import 'package:academic_planner/src/core/database/migrations/migration_v1.dart';
import 'package:academic_planner/src/core/database/migrations/migration_v2.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static Database? _db;

  static final _migrations = <Migration>[MigrationV1(), MigrationV2()];

  static Future<Database> get instance async {
    if (_db != null) return _db!;

    _migrations.sort((a, b) => a.version.compareTo(b.version));

    _db = await openDatabase(
      'academic_planner.db',
      version: _migrations.last.version,
      onCreate: (db, version) async {
        for (final migration in _migrations) {
          await migration.up(db);
        }
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        for (final migration in _migrations) {
          if (migration.version > oldVersion &&
              migration.version <= newVersion) {
            await migration.up(db);
          }
        }
      },
      onDowngrade: (db, oldVersion, newVersion) async {
        for (final migration in _migrations.reversed) {
          if (migration.version <= oldVersion &&
              migration.version > newVersion) {
            await migration.down(db);
          }
        }
      },
    );

    return _db!;
  }
}
