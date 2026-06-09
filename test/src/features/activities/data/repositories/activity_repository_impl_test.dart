import 'package:academic_planner/src/core/domain/entities/pagination.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/activities/data/data_source/activity_local_datasource.dart';
import 'package:academic_planner/src/features/activities/data/repositories/activity_repository_impl.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockActivityLocalDataSource extends Mock
    implements ActivityLocalDataSource {}

Activity _baseActivity({String id = 'act-1'}) => Activity(
  id: id,
  title: 'Calculus Exam',
  description: 'Chapter 1-3',
  disciplineId: 1,
  tags: const [],
  reminders: const [],
  status: ActivityStatus.pending,
  createdAt: DateTime.parse('2024-01-01T00:00:00.000'),
  updatedAt: DateTime.parse('2024-01-01T00:00:00.000'),
);

Map<String, dynamic> _activityRow({String id = 'act-1'}) => {
  'id': id,
  'title': 'Calculus Exam',
  'description': 'Chapter 1-3',
  'notes': null,
  'disciplineId': 1,
  'dueDate': null,
  'category': null,
  'tags': '[]',
  'reminders': '[]',
  'status': 'pending',
  'createdAt': '2024-01-01T00:00:00.000',
  'updatedAt': '2024-01-01T00:00:00.000',
};

void main() {
  late MockActivityLocalDataSource mockDs;
  late ActivityRepositoryImpl sut;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(const ActivityFilter());
    registerFallbackValue(const Pagination(limit: 10));
  });

  setUp(() {
    mockDs = MockActivityLocalDataSource();
    sut = ActivityRepositoryImpl(mockDs);
  });

  group('add', () {
    test('success → returns Success', () async {
      when(() => mockDs.insert(any())).thenAnswer((_) async {});

      final result = await sut.add(_baseActivity());

      expect(result, isA<Success<void>>());
      verify(() => mockDs.insert(any())).called(1);
    });

    test('exception → returns Failure', () async {
      when(() => mockDs.insert(any())).thenThrow(Exception('db error'));

      final result = await sut.add(_baseActivity());

      expect(result, isA<Failure<void>>());
    });
  });

  group('getAll', () {
    test('empty result → Success with empty list', () async {
      when(
        () => mockDs.getAll(
          filter: any(named: 'filter'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((_) async => []);

      final result = await sut.getAll();

      expect(result, isA<Success<List<Activity>>>());
      expect((result as Success<List<Activity>>).value, isEmpty);
    });

    test('rows returned → Success with mapped activities', () async {
      when(
        () => mockDs.getAll(
          filter: any(named: 'filter'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((_) async => [_activityRow(id: '1'), _activityRow(id: '2')]);

      final result = await sut.getAll();

      expect(result, isA<Success<List<Activity>>>());
      expect((result as Success<List<Activity>>).value.length, 2);
    });

    test('exception → returns Failure', () async {
      when(
        () => mockDs.getAll(
          filter: any(named: 'filter'),
          pagination: any(named: 'pagination'),
        ),
      ).thenThrow(Exception('db error'));

      final result = await sut.getAll();

      expect(result, isA<Failure<List<Activity>>>());
    });
  });

  group('getById', () {
    test('row found → Success with mapped activity', () async {
      when(() => mockDs.getById(any()))
          .thenAnswer((_) async => _activityRow());

      final result = await sut.getById('act-1');

      expect(result, isA<Success<Activity?>>());
      expect((result as Success<Activity?>).value?.id, 'act-1');
    });

    test('null returned → Success(null)', () async {
      when(() => mockDs.getById(any())).thenAnswer((_) async => null);

      final result = await sut.getById('no-such-id');

      expect(result, isA<Success<Activity?>>());
      expect((result as Success<Activity?>).value, isNull);
    });

    test('exception → returns Failure', () async {
      when(() => mockDs.getById(any())).thenThrow(Exception('db error'));

      final result = await sut.getById('act-1');

      expect(result, isA<Failure<Activity?>>());
    });
  });

  group('update', () {
    test('success → returns Success', () async {
      when(() => mockDs.update(any(), any())).thenAnswer((_) async {});

      final result = await sut.update(_baseActivity());

      expect(result, isA<Success<void>>());
      verify(() => mockDs.update('act-1', any())).called(1);
    });

    test('exception → returns Failure', () async {
      when(() => mockDs.update(any(), any())).thenThrow(Exception('db error'));

      final result = await sut.update(_baseActivity());

      expect(result, isA<Failure<void>>());
    });
  });

  group('delete', () {
    test('success → returns Success', () async {
      when(() => mockDs.delete(any())).thenAnswer((_) async {});

      final result = await sut.delete('act-1');

      expect(result, isA<Success<void>>());
      verify(() => mockDs.delete('act-1')).called(1);
    });

    test('exception → returns Failure', () async {
      when(() => mockDs.delete(any())).thenThrow(Exception('db error'));

      final result = await sut.delete('act-1');

      expect(result, isA<Failure<void>>());
    });
  });

  group('deleteAll', () {
    test('success → returns Success', () async {
      when(() => mockDs.deleteAll()).thenAnswer((_) async {});

      final result = await sut.deleteAll();

      expect(result, isA<Success<void>>());
      verify(() => mockDs.deleteAll()).called(1);
    });

    test('exception → returns Failure', () async {
      when(() => mockDs.deleteAll()).thenThrow(Exception('db error'));

      final result = await sut.deleteAll();

      expect(result, isA<Failure<void>>());
    });
  });
}
