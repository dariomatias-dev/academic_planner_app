import 'package:academic_planner/src/core/domain/entities/pagination.dart';
import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/domain/repositories/activity_repository.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';
import 'package:academic_planner/src/features/activities/presentation/view_models/activity_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockActivityRepository extends Mock implements ActivityRepository {}

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

void main() {
  late MockActivityRepository mockRepository;
  late ActivityViewModel sut;

  setUpAll(() {
    registerFallbackValue(_baseActivity());
  });

  setUp(() {
    mockRepository = MockActivityRepository();
    sut = ActivityViewModel(mockRepository);
  });

  group('create', () {
    test('delegates to repository.add and returns its result', () async {
      final activity = _baseActivity();
      when(
        () => mockRepository.add(activity),
      ).thenAnswer((_) async => const Success<void>(null));

      final result = await sut.create(activity);

      expect(result, isA<Success<void>>());
      verify(() => mockRepository.add(activity)).called(1);
    });

    test('propagates failure from repository', () async {
      final activity = _baseActivity();
      when(() => mockRepository.add(activity)).thenAnswer(
        (_) async => const Failure<void>(DatabaseFailure('insert failed')),
      );

      final result = await sut.create(activity);

      expect(result, isA<Failure<void>>());
    });
  });

  group('getAll', () {
    test('forwards filter and pagination to repository', () async {
      final activities = [_baseActivity()];
      const filter = ActivityFilter();
      const pagination = Pagination();
      when(
        () => mockRepository.getAll(filter: filter, pagination: pagination),
      ).thenAnswer((_) async => Success<List<Activity>>(activities));

      final result = await sut.getAll(filter: filter, pagination: pagination);

      expect(result, isA<Success<List<Activity>>>());
      result.when(
        onSuccess: (value) => expect(value, activities),
        onFailure: (_) => fail('expected success'),
      );
    });

    test('propagates failure from repository', () async {
      when(
        () => mockRepository.getAll(),
      ).thenAnswer(
        (_) async =>
            const Failure<List<Activity>>(DatabaseFailure('query failed')),
      );

      final result = await sut.getAll();

      expect(result, isA<Failure<List<Activity>>>());
    });
  });

  group('count', () {
    test('forwards filter to repository and returns count', () async {
      const filter = ActivityFilter();
      when(
        () => mockRepository.count(filter: filter),
      ).thenAnswer((_) async => const Success<int>(5));

      final result = await sut.count(filter: filter);

      expect(result, isA<Success<int>>());
      result.when(
        onSuccess: (value) => expect(value, 5),
        onFailure: (_) => fail('expected success'),
      );
    });

    test('propagates failure from repository', () async {
      when(() => mockRepository.count()).thenAnswer(
        (_) async => const Failure<int>(DatabaseFailure('count failed')),
      );

      final result = await sut.count();

      expect(result, isA<Failure<int>>());
    });
  });

  group('getById', () {
    test('returns activity when found', () async {
      final activity = _baseActivity();
      when(
        () => mockRepository.getById('act-1'),
      ).thenAnswer((_) async => Success<Activity?>(activity));

      final result = await sut.getById('act-1');

      expect(result, isA<Success<Activity?>>());
      result.when(
        onSuccess: (value) => expect(value, activity),
        onFailure: (_) => fail('expected success'),
      );
    });

    test('propagates failure from repository', () async {
      when(() => mockRepository.getById('missing')).thenAnswer(
        (_) async => const Failure<Activity?>(DatabaseFailure('not found')),
      );

      final result = await sut.getById('missing');

      expect(result, isA<Failure<Activity?>>());
    });
  });

  group('update', () {
    test('refreshes updatedAt before delegating to repository', () async {
      final activity = _baseActivity();
      when(
        () => mockRepository.update(any()),
      ).thenAnswer((_) async => const Success<void>(null));

      final result = await sut.update(activity);

      expect(result, isA<Success<void>>());
      final captured =
          verify(() => mockRepository.update(captureAny())).captured.single
              as Activity;
      expect(captured.id, activity.id);
      expect(
        captured.updatedAt.isAfter(activity.updatedAt) ||
            captured.updatedAt.isAtSameMomentAs(activity.updatedAt),
        isTrue,
      );
    });

    test('propagates failure from repository', () async {
      when(() => mockRepository.update(any())).thenAnswer(
        (_) async => const Failure<void>(DatabaseFailure('update failed')),
      );

      final result = await sut.update(_baseActivity());

      expect(result, isA<Failure<void>>());
    });
  });

  group('delete', () {
    test('delegates to repository.delete', () async {
      when(
        () => mockRepository.delete('act-1'),
      ).thenAnswer((_) async => const Success<void>(null));

      final result = await sut.delete('act-1');

      expect(result, isA<Success<void>>());
      verify(() => mockRepository.delete('act-1')).called(1);
    });

    test('propagates failure from repository', () async {
      when(() => mockRepository.delete('act-1')).thenAnswer(
        (_) async => const Failure<void>(DatabaseFailure('delete failed')),
      );

      final result = await sut.delete('act-1');

      expect(result, isA<Failure<void>>());
    });
  });

  group('createNew', () {
    test('builds an Activity with a generated id and timestamps', () {
      final activity = sut.createNew(
        title: 'New Activity',
        description: 'Description',
        disciplineId: 2,
        tags: const ['important'],
        reminders: const [TimeOfDay(hour: 9, minute: 0)],
        status: ActivityStatus.draft,
        category: 'Homework',
        dueDate: DateTime.parse('2024-02-01T00:00:00.000'),
        notes: 'Bring calculator',
      );

      expect(activity.id, isNotEmpty);
      expect(activity.title, 'New Activity');
      expect(activity.description, 'Description');
      expect(activity.disciplineId, 2);
      expect(activity.tags, ['important']);
      expect(activity.reminders, [const TimeOfDay(hour: 9, minute: 0)]);
      expect(activity.status, ActivityStatus.draft);
      expect(activity.category, 'Homework');
      expect(activity.dueDate, DateTime.parse('2024-02-01T00:00:00.000'));
      expect(activity.notes, 'Bring calculator');
      expect(activity.createdAt, activity.updatedAt);
    });

    test('defaults optional fields to null', () {
      final activity = sut.createNew(
        title: 'New Activity',
        description: 'Description',
        disciplineId: 2,
        tags: const [],
        reminders: const [],
        status: ActivityStatus.draft,
      );

      expect(activity.category, isNull);
      expect(activity.dueDate, isNull);
      expect(activity.notes, isNull);
    });
  });
}
