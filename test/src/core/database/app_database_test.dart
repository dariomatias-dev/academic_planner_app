import 'dart:io';

import 'package:academic_planner/src/core/database/app_database.dart';
import 'package:academic_planner/src/core/database/migrations/migration_v1.dart';
import 'package:academic_planner/src/core/database/tables/activity_table.dart';
import 'package:academic_planner/src/core/database/tables/note_table.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<bool> _tableExists(Database db, String tableName) async {
  final rows = await db.query(
    'sqlite_master',
    where: 'type = ? AND name = ?',
    whereArgs: ['table', tableName],
  );

  return rows.isNotEmpty;
}

void main() {
  late Directory tempDir;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('app_database_test');
  });

  tearDown(() {
    tempDir.deleteSync(recursive: true);
  });

  group('AppDatabase.open', () {
    test('fresh database applies every migration', () async {
      final db = await AppDatabase.open(
        path: '${tempDir.path}/fresh.db',
      );

      expect(await _tableExists(db, ActivityTable.tableName), isTrue);
      expect(await _tableExists(db, NoteTable.tableName), isTrue);

      await db.close();
    });

    test('upgrading from v1 to v2 adds the notes table', () async {
      final path = '${tempDir.path}/upgrade.db';

      final v1 = await databaseFactory.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, _) => MigrationV1().up(db),
        ),
      );
      await v1.insert('activities', {
        'id': '1',
        'title': 'Prova',
        'description': 'Prova de cálculo',
        'disciplineId': 1,
        'createdAt': '2024-01-01T00:00:00.000',
        'updatedAt': '2024-01-01T00:00:00.000',
      });
      await v1.close();

      final upgraded = await AppDatabase.open(path: path);

      expect(await _tableExists(upgraded, NoteTable.tableName), isTrue);
      expect(await upgraded.query('activities'), hasLength(1));

      await upgraded.close();
    });

    test('downgrading from v2 to v1 drops the notes table', () async {
      final path = '${tempDir.path}/downgrade.db';

      final v2 = await AppDatabase.open(path: path);
      await v2.close();

      final downgraded = await AppDatabase.open(path: path, version: 1);

      expect(await _tableExists(downgraded, NoteTable.tableName), isFalse);
      expect(await _tableExists(downgraded, ActivityTable.tableName), isTrue);

      await downgraded.close();
    });
  });
}
