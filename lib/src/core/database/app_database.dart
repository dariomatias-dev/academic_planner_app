import 'package:academic_planner/src/core/database/migrations/migration.dart';
import 'package:academic_planner/src/core/database/migrations/migration_v1.dart';
import 'package:academic_planner/src/core/database/migrations/migration_v2.dart';
import 'package:sqflite/sqflite.dart';

/// Opens the app's SQLite database, applying every migration up to the
/// requested `version` (the latest one by default). Called once from the
/// bootstrap sequence in `main()`; the resulting `Database` is injected
/// through `appDatabaseProvider` rather than cached here.
class AppDatabase {
  AppDatabase._();

  static final migrations = <Migration>[MigrationV1(), MigrationV2()]
    ..sort((a, b) => a.version.compareTo(b.version));

  static Future<Database> open({
    String path = 'academic_planner.db',
    int? version,
  }) {
    return openDatabase(
      path,
      version: version ?? migrations.last.version,
      onCreate: (db, version) async {
        for (final migration in migrations) {
          await migration.up(db);
        }
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        for (final migration in migrations) {
          if (migration.version > oldVersion &&
              migration.version <= newVersion) {
            await migration.up(db);
          }
        }
      },
      onDowngrade: (db, oldVersion, newVersion) async {
        for (final migration in migrations.reversed) {
          if (migration.version <= oldVersion &&
              migration.version > newVersion) {
            await migration.down(db);
          }
        }
      },
    );
  }
}
