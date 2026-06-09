import 'package:academic_planner/src/core/database/tables/note_table.dart';
import 'package:academic_planner/src/features/notes/data/data_source/note_local_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Map<String, dynamic> _row({
  required String id,
  String title = 'Lecture Note',
  String content = 'Content',
  int disciplineId = 1,
  String? createdAt,
  String? updatedAt,
}) {
  const base = '2024-01-01T00:00:00.000';
  return {
    'id': id,
    'title': title,
    'content': content,
    'disciplineId': disciplineId,
    'createdAt': createdAt ?? base,
    'updatedAt': updatedAt ?? base,
  };
}

void main() {
  late Database db;
  late NoteLocalDataSource sut;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    db = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, _) => db.execute(NoteTable.createTableQuery),
      ),
    );
    sut = NoteLocalDataSource(db);
  });

  tearDown(() => db.close());

  group('insert / getById', () {
    test('insert → getById returns record', () async {
      await sut.insert(_row(id: '1', title: 'Calculus I'));
      final result = await sut.getById('1');
      expect(result, isNotNull);
      expect(result!['title'], 'Calculus I');
    });

    test('getById non-existent id → null', () async {
      expect(await sut.getById('nao-existe'), isNull);
    });

    test('insert duplicate id → throws', () async {
      await sut.insert(_row(id: '1'));
      expect(() => sut.insert(_row(id: '1')), throwsA(anything));
    });
  });

  group('getAll', () {
    test('empty table → empty list', () async {
      expect(await sut.getAll(), isEmpty);
    });

    test('returns all records', () async {
      await sut.insert(_row(id: '1'));
      await sut.insert(_row(id: '2'));
      await sut.insert(_row(id: '3'));
      expect((await sut.getAll()).length, 3);
    });

    test('ordered by updatedAt DESC', () async {
      await sut.insert(_row(id: '1', updatedAt: '2024-01-10T00:00:00.000'));
      await sut.insert(_row(id: '2', updatedAt: '2024-03-10T00:00:00.000'));
      await sut.insert(_row(id: '3', updatedAt: '2024-02-10T00:00:00.000'));
      final result = await sut.getAll();
      expect(result.map((r) => r['id']).toList(), ['2', '3', '1']);
    });
  });

  group('update', () {
    test('updates field → getById reflects new value', () async {
      await sut.insert(_row(id: '1', title: 'Old'));
      await sut.update('1', {
        'title': 'New',
        'updatedAt': '2024-06-01T00:00:00.000',
      });
      final result = await sut.getById('1');
      expect(result!['title'], 'New');
    });

    test('update non-existent id → completes without error', () async {
      await expectLater(
        sut.update('nao-existe', {
          'title': 'X',
          'updatedAt': '2024-01-01T00:00:00.000',
        }),
        completes,
      );
    });

    test('update does not affect other records', () async {
      await sut.insert(_row(id: '1', title: 'A'));
      await sut.insert(_row(id: '2', title: 'B'));
      await sut.update('1', {
        'title': 'A updated',
        'updatedAt': '2024-06-01T00:00:00.000',
      });
      final other = await sut.getById('2');
      expect(other!['title'], 'B');
    });
  });

  group('delete', () {
    test('delete → getById returns null', () async {
      await sut.insert(_row(id: '1'));
      await sut.delete('1');
      expect(await sut.getById('1'), isNull);
    });

    test('delete does not affect other records', () async {
      await sut.insert(_row(id: '1'));
      await sut.insert(_row(id: '2'));
      await sut.delete('1');
      expect(await sut.getById('2'), isNotNull);
    });

    test('delete non-existent id → completes without error', () async {
      await expectLater(sut.delete('nao-existe'), completes);
    });
  });
}
