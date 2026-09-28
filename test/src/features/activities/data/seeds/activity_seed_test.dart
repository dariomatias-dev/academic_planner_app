import 'package:academic_planner/src/core/database/tables/activity_table.dart';
import 'package:academic_planner/src/features/activities/data/seeds/activity_seed.dart';
import 'package:academic_planner/src/features/activities/data/seeds/activity_seed_data.dart';
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

  group('ActivitySeed', () {
    test('run inserts every seed activity', () async {
      await ActivitySeed(db).run();

      final count = await db.query(ActivityTable.tableName);

      expect(count, hasLength(activitySeedData.length));
    });

    test('running it again does not duplicate data', () async {
      final seed = ActivitySeed(db);

      await seed.run();
      await seed.run();

      final rows = await db.query(ActivityTable.tableName);

      expect(rows, hasLength(activitySeedData.length));
    });
  });
}
