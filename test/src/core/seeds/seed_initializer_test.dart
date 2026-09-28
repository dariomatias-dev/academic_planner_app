import 'package:academic_planner/src/core/database/tables/activity_table.dart';
import 'package:academic_planner/src/core/seeds/seed_initializer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Database db;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    db = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, _) => db.execute(ActivityTable.createTableQuery),
      ),
    );
  });

  tearDown(() => db.close());

  group('runDevSeeds', () {
    test(
      'does nothing when SEED_ENABLED was not passed at build time',
      () async {
        await runDevSeeds(db);

        final rows = await db.query(ActivityTable.tableName);

        expect(rows, isEmpty);
      },
    );
  });
}
