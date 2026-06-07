import 'dart:convert';

import 'package:academic_planner/src/core/database/tables/activity_table.dart';
import 'package:academic_planner/src/core/domain/entities/pagination.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/features/activities/data/data_source/activity_local_datasource.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_sort_field.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_sort_order.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Map<String, dynamic> _row({
  required String id,
  String title = 'Activity',
  String description = 'Description',
  String? notes,
  int disciplineId = 1,
  String? dueDate,
  String? category,
  List<String> tags = const [],
  String status = 'pending',
  String? createdAt,
  String? updatedAt,
}) {
  const base = '2024-01-01T00:00:00.000';
  return {
    'id': id,
    'title': title,
    'description': description,
    'notes': notes,
    'disciplineId': disciplineId,
    'dueDate': dueDate,
    'category': category,
    'tags': jsonEncode(tags),
    'reminders': jsonEncode([]),
    'status': status,
    'createdAt': createdAt ?? base,
    'updatedAt': updatedAt ?? base,
  };
}

void main() {
  late Database db;
  late ActivityLocalDataSource sut;

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
    sut = ActivityLocalDataSource(db);
  });

  tearDown(() => db.close());

  group('insert / getById', () {
    test('insert → getById returns record', () async {
      await sut.insert(_row(id: '1', title: 'Calculus Exam'));
      final result = await sut.getById('1');
      expect(result, isNotNull);
      expect(result!['title'], 'Calculus Exam');
    });

    test('getById for non-existent id → null', () async {
      expect(await sut.getById('non-existent'), isNull);
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
  });

  group('update', () {
    test('updates field → getById reflects new value', () async {
      await sut.insert(_row(id: '1', title: 'Old title'));
      await sut.update('1', {
        'title': 'New title',
        'updatedAt': '2024-06-01T00:00:00.000',
      });
      final result = await sut.getById('1');
      expect(result!['title'], 'New title');
    });

    test('update non-existent id → completes without error', () async {
      await expectLater(
        sut.update('non-existent', {
          'title': 'X',
          'updatedAt': '2024-01-01T00:00:00.000',
        }),
        completes,
      );
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
      await expectLater(sut.delete('non-existent'), completes);
    });
  });

  group('deleteAll', () {
    test('removes all records', () async {
      await sut.insert(_row(id: '1'));
      await sut.insert(_row(id: '2'));
      await sut.deleteAll();
      expect(await sut.getAll(), isEmpty);
    });

    test('already empty table → completes without error', () async {
      await expectLater(sut.deleteAll(), completes);
    });
  });

  group('filter — search', () {
    setUp(() async {
      await sut.insert(_row(id: '1', title: 'Calculus Exam'));
      await sut.insert(_row(id: '2', title: 'Physics Paper'));
      await sut.insert(_row(id: '3', title: 'Art Seminar'));
    });

    test('partial search → returns match', () async {
      final result = await sut.getAll(
        filter: const ActivityFilter(search: 'Calculus'),
      );
      expect(result.length, 1);
      expect(result.first['id'], '1');
    });

    test('lowercase search → case-insensitive via LIKE', () async {
      final result = await sut.getAll(
        filter: const ActivityFilter(search: 'physics'),
      );
      expect(result.length, 1);
      expect(result.first['id'], '2');
    });

    test('search with no match → empty list', () async {
      final result = await sut.getAll(
        filter: const ActivityFilter(search: 'Chemistry'),
      );
      expect(result, isEmpty);
    });

    test('empty search → returns all', () async {
      final result = await sut.getAll(filter: const ActivityFilter(search: ''));
      expect(result.length, 3);
    });

    test('substring in middle of title → finds record', () async {
      final result = await sut.getAll(
        filter: const ActivityFilter(search: 'Paper'),
      );
      expect(result.length, 1);
      expect(result.first['id'], '2');
    });
  });

  group('filter — statuses', () {
    setUp(() async {
      await sut.insert(_row(id: '1'));
      await sut.insert(_row(id: '2', status: 'inProgress'));
      await sut.insert(_row(id: '3', status: 'completed'));
      await sut.insert(_row(id: '4', status: 'completed'));
    });

    test('single status → returns only that status', () async {
      final result = await sut.getAll(
        filter: const ActivityFilter(statuses: [ActivityStatus.pending]),
      );
      expect(result.length, 1);
      expect(result.first['status'], 'pending');
    });

    test('multiple statuses → returns all matches', () async {
      final result = await sut.getAll(
        filter: const ActivityFilter(
          statuses: [ActivityStatus.inProgress, ActivityStatus.completed],
        ),
      );
      expect(result.length, 3);
    });

    test('empty status list → returns all', () async {
      final result = await sut.getAll(
        filter: const ActivityFilter(statuses: []),
      );
      expect(result.length, 4);
    });

    test('status with no occurrence → empty list', () async {
      final result = await sut.getAll(
        filter: const ActivityFilter(statuses: [ActivityStatus.canceled]),
      );
      expect(result, isEmpty);
    });
  });

  group('filter — tags', () {
    setUp(() async {
      await sut.insert(_row(id: '1', tags: ['flutter', 'dart']));
      await sut.insert(_row(id: '2', tags: ['dart', 'mobile']));
      await sut.insert(_row(id: '3', tags: ['backend', 'api']));
      await sut.insert(_row(id: '4', tags: []));
    });

    test('single tag → returns activities with that tag', () async {
      final result = await sut.getAll(
        filter: const ActivityFilter(tags: ['flutter']),
      );
      expect(result.length, 1);
      expect(result.first['id'], '1');
    });

    test('shared tag → returns all that have it', () async {
      final result = await sut.getAll(
        filter: const ActivityFilter(tags: ['dart']),
      );
      expect(result.length, 2);
      expect(result.map((r) => r['id']).toSet(), {'1', '2'});
    });

    test('multiple tags → AND logic (all must be present)', () async {
      final result = await sut.getAll(
        filter: const ActivityFilter(tags: ['flutter', 'dart']),
      );
      expect(result.length, 1);
      expect(result.first['id'], '1');
    });

    test('non-existent tag → empty list', () async {
      final result = await sut.getAll(
        filter: const ActivityFilter(tags: ['nonexistent']),
      );
      expect(result, isEmpty);
    });

    test('activity without tags is not returned by tag filter', () async {
      final result = await sut.getAll(
        filter: const ActivityFilter(tags: ['flutter']),
      );
      expect(result.every((r) => r['id'] != '4'), isTrue);
    });
  });

  group('filter — dateRange (startDate / endDate)', () {
    setUp(() async {
      await sut.insert(_row(id: '1', dueDate: '2024-01-10T00:00:00.000'));
      await sut.insert(_row(id: '2', dueDate: '2024-03-15T00:00:00.000'));
      await sut.insert(_row(id: '3', dueDate: '2024-06-20T00:00:00.000'));
      await sut.insert(_row(id: '4'));
    });

    test('startDate → returns dueDate >= startDate', () async {
      final result = await sut.getAll(
        filter: ActivityFilter(startDate: DateTime(2024, 3)),
      );
      expect(result.map((r) => r['id']).toSet(), {'2', '3'});
    });

    test('endDate → returns dueDate <= endDate', () async {
      final result = await sut.getAll(
        filter: ActivityFilter(endDate: DateTime(2024, 3, 31)),
      );
      expect(result.map((r) => r['id']).toSet(), {'1', '2'});
    });

    test('startDate + endDate → closed interval', () async {
      final result = await sut.getAll(
        filter: ActivityFilter(
          startDate: DateTime(2024, 2),
          endDate: DateTime(2024, 5),
        ),
      );
      expect(result.length, 1);
      expect(result.first['id'], '2');
    });

    test('dueAfter / dueBefore equivalent to startDate/endDate', () async {
      final result = await sut.getAll(
        filter: ActivityFilter(
          dueAfter: DateTime(2024, 6),
          dueBefore: DateTime(2024, 12, 31),
        ),
      );
      expect(result.length, 1);
      expect(result.first['id'], '3');
    });

    test('interval with no match → empty list', () async {
      final result = await sut.getAll(
        filter: ActivityFilter(
          startDate: DateTime(2025),
          endDate: DateTime(2025, 12, 31),
        ),
      );
      expect(result, isEmpty);
    });

    test('activity without dueDate not included in date filter', () async {
      final result = await sut.getAll(
        filter: ActivityFilter(startDate: DateTime(2020)),
      );
      expect(result.every((r) => r['id'] != '4'), isTrue);
    });
  });

  group('filter — disciplineId', () {
    setUp(() async {
      await sut.insert(_row(id: '1', disciplineId: 10));
      await sut.insert(_row(id: '2', disciplineId: 20));
      await sut.insert(_row(id: '3', disciplineId: 10));
    });

    test('disciplineId → returns only activities of that discipline', () async {
      final result = await sut.getAll(
        filter: const ActivityFilter(disciplineId: 10),
      );
      expect(result.length, 2);
      expect(result.every((r) => r['disciplineId'] == 10), isTrue);
    });

    test('non-existent disciplineId → empty list', () async {
      final result = await sut.getAll(
        filter: const ActivityFilter(disciplineId: 99),
      );
      expect(result, isEmpty);
    });
  });

  group('filter — category', () {
    setUp(() async {
      await sut.insert(_row(id: '1', category: 'Exam'));
      await sut.insert(_row(id: '2', category: 'Assignment'));
      await sut.insert(_row(id: '3', category: 'Exam'));
    });

    test('category → returns only activities of that category', () async {
      final result = await sut.getAll(
        filter: const ActivityFilter(category: 'Exam'),
      );
      expect(result.length, 2);
      expect(result.every((r) => r['category'] == 'Exam'), isTrue);
    });
  });

  group('combined filters', () {
    setUp(() async {
      await sut.insert(
        _row(
          id: '1',
          title: 'Calculus Exam',
          tags: ['math'],
          dueDate: '2024-03-10T00:00:00.000',
          category: 'Exam',
        ),
      );
      await sut.insert(
        _row(
          id: '2',
          title: 'Physics Exam',
          status: 'completed',
          tags: ['physics'],
          dueDate: '2024-03-20T00:00:00.000',
          category: 'Exam',
        ),
      );
      await sut.insert(
        _row(
          id: '3',
          title: 'Art Assignment',
          tags: ['art'],
          dueDate: '2024-04-05T00:00:00.000',
          disciplineId: 2,
          category: 'Assignment',
        ),
      );
    });

    test('search + status → correct intersection', () async {
      final result = await sut.getAll(
        filter: const ActivityFilter(
          search: 'Exam',
          statuses: [ActivityStatus.pending],
        ),
      );
      expect(result.length, 1);
      expect(result.first['id'], '1');
    });

    test('search + tags + dateRange → no false positives', () async {
      final result = await sut.getAll(
        filter: ActivityFilter(
          search: 'Exam',
          tags: const ['math'],
          startDate: DateTime(2024, 3),
          endDate: DateTime(2024, 3, 15),
        ),
      );
      expect(result.length, 1);
      expect(result.first['id'], '1');
    });

    test('status + disciplineId + tags → precise filter', () async {
      final result = await sut.getAll(
        filter: const ActivityFilter(
          statuses: [ActivityStatus.pending],
          disciplineId: 1,
          tags: ['math'],
        ),
      );
      expect(result.length, 1);
      expect(result.first['id'], '1');
    });

    test('category + status → returns only intersection', () async {
      final result = await sut.getAll(
        filter: const ActivityFilter(
          category: 'Exam',
          statuses: [ActivityStatus.completed],
        ),
      );
      expect(result.length, 1);
      expect(result.first['id'], '2');
    });

    test('filter with no match → empty list', () async {
      final result = await sut.getAll(
        filter: const ActivityFilter(
          search: 'Chemistry',
          statuses: [ActivityStatus.inProgress],
        ),
      );
      expect(result, isEmpty);
    });

    test('all filters combined → unique result', () async {
      final result = await sut.getAll(
        filter: ActivityFilter(
          search: 'Calculus',
          statuses: const [ActivityStatus.pending],
          tags: const ['math'],
          disciplineId: 1,
          category: 'Exam',
          startDate: DateTime(2024, 3),
          endDate: DateTime(2024, 3, 31),
        ),
      );
      expect(result.length, 1);
      expect(result.first['id'], '1');
    });
  });

  group('pagination', () {
    setUp(() async {
      for (var i = 1; i <= 10; i++) {
        await sut.insert(
          _row(
            id: '$i',
            title: 'Activity $i',
            createdAt: DateTime(2024, 1, i).toIso8601String(),
            updatedAt: DateTime(2024, 1, i).toIso8601String(),
          ),
        );
      }
    });

    test('limit → returns at most N records', () async {
      final result = await sut.getAll(
        pagination: const Pagination(limit: 3),
      );
      expect(result.length, 3);
    });

    test('page 0 and page 1 do not overlap', () async {
      const filter = ActivityFilter(
        sortField: ActivitySortField.createdAt,
        sortOrder: ActivitySortOrder.asc,
      );
      final page0 = await sut.getAll(
        filter: filter,
        pagination: const Pagination(limit: 5),
      );
      final page1 = await sut.getAll(
        filter: filter,
        pagination: const Pagination(page: 1, limit: 5),
      );
      final ids0 = page0.map((r) => r['id']).toSet();
      final ids1 = page1.map((r) => r['id']).toSet();
      expect(ids0.intersection(ids1), isEmpty);
      expect(ids0.length + ids1.length, 10);
    });

    test('page beyond total → empty list', () async {
      final result = await sut.getAll(
        pagination: const Pagination(page: 5, limit: 10),
      );
      expect(result, isEmpty);
    });

    test('last partial page → returns remainder', () async {
      const filter = ActivityFilter(
        sortField: ActivitySortField.createdAt,
        sortOrder: ActivitySortOrder.asc,
      );

      final result = await sut.getAll(
        filter: filter,
        pagination: const Pagination(page: 1, limit: 7),
      );
      expect(result.length, 3);
    });

    test('pagination + status filter → paginates filtered result', () async {
      for (var i = 11; i <= 15; i++) {
        await sut.insert(
          _row(
            id: '$i',
            status: 'completed',
            createdAt: DateTime(2024, 2, i - 10).toIso8601String(),
            updatedAt: DateTime(2024, 2, i - 10).toIso8601String(),
          ),
        );
      }
      final result = await sut.getAll(
        filter: const ActivityFilter(
          statuses: [ActivityStatus.completed],
          sortField: ActivitySortField.createdAt,
          sortOrder: ActivitySortOrder.asc,
        ),
        pagination: const Pagination(limit: 3),
      );
      expect(result.length, 3);
      expect(result.every((r) => r['status'] == 'completed'), isTrue);
    });
  });

  group('count', () {
    setUp(() async {
      await sut.insert(_row(id: '1'));
      await sut.insert(_row(id: '2'));
      await sut.insert(_row(id: '3', status: 'completed'));
    });

    test('no filter → total record count', () async {
      expect(await sut.count(), 3);
    });

    test('status filter → filtered count', () async {
      expect(
        await sut.count(
          filter: const ActivityFilter(statuses: [ActivityStatus.pending]),
        ),
        2,
      );
    });

    test('empty table → 0', () async {
      await sut.deleteAll();
      expect(await sut.count(), 0);
    });

    test('filter with no match → 0', () async {
      expect(
        await sut.count(
          filter: const ActivityFilter(statuses: [ActivityStatus.canceled]),
        ),
        0,
      );
    });
  });

  group('sort', () {
    setUp(() async {
      await sut.insert(
        _row(id: '1', title: 'Zebra', dueDate: '2024-03-01T00:00:00.000'),
      );
      await sut.insert(
        _row(id: '2', title: 'Alpha', dueDate: '2024-01-01T00:00:00.000'),
      );
      await sut.insert(
        _row(id: '3', title: 'Mango', dueDate: '2024-06-01T00:00:00.000'),
      );
    });

    test('title ASC → alphabetical order', () async {
      final result = await sut.getAll(
        filter: const ActivityFilter(
          sortField: ActivitySortField.title,
          sortOrder: ActivitySortOrder.asc,
        ),
      );
      expect(result.builder((r, inded) => r['title']), [
        'Alpha',
        'Mango',
        'Zebra',
      ]);
    });

    test('title DESC → reverse alphabetical order', () async {
      final result = await sut.getAll(
        filter: const ActivityFilter(
          sortField: ActivitySortField.title,
          sortOrder: ActivitySortOrder.desc,
        ),
      );
      expect(result.builder((r, inded) => r['title']), [
        'Zebra',
        'Mango',
        'Alpha',
      ]);
    });

    test('dueDate ASC → ascending date order', () async {
      final result = await sut.getAll(
        filter: const ActivityFilter(
          sortField: ActivitySortField.dueDate,
          sortOrder: ActivitySortOrder.asc,
        ),
      );
      final dates = result.builder((r, inded) => r['dueDate'] as String);
      expect(dates, ([...dates]..sort()));
    });

    test('dueDate DESC → descending date order', () async {
      final result = await sut.getAll(
        filter: const ActivityFilter(
          sortField: ActivitySortField.dueDate,
          sortOrder: ActivitySortOrder.desc,
        ),
      );
      final dates = result.builder((r, inded) => r['dueDate'] as String);
      expect(dates, ([...dates]..sort()).reversed.toList());
    });

    test('no sortField → returns records without error', () async {
      final result = await sut.getAll();
      expect(result.length, 3);
    });
  });
}
