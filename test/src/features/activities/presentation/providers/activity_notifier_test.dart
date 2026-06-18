import 'package:academic_planner/src/core/domain/entities/pagination.dart';
import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity_stats.dart';
import 'package:academic_planner/src/features/activities/domain/repositories/activity_repository.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';
import 'package:academic_planner/src/features/activities/presentation/providers/activity_stats_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockActivityRepository extends Mock implements ActivityRepository {}

class _FakeActivityStatsNotifier extends ActivityStatsNotifier {
  int refreshCalls = 0;

  @override
  Future<ActivityStats> build() async {
    return const ActivityStats(
      total: 0,
      active: 0,
      completed: 0,
      urgent: 0,
      progress: 0,
    );
  }

  @override
  Future<void> refresh() async {
    refreshCalls++;
  }
}

Activity _activity({String id = '1'}) => Activity(
  id: id,
  title: 'Title',
  description: 'Description',
  disciplineId: 1,
  tags: const [],
  reminders: const [],
  status: ActivityStatus.pending,
);

void main() {
  late MockActivityRepository mockRepository;
  late _FakeActivityStatsNotifier fakeStatsNotifier;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(_activity());
    registerFallbackValue(const ActivityFilter());
    registerFallbackValue(const Pagination());
  });

  setUp(() {
    mockRepository = MockActivityRepository();
    fakeStatsNotifier = _FakeActivityStatsNotifier();
    container = ProviderContainer(
      overrides: [
        activityRepositoryProvider.overrideWithValue(mockRepository),
        activityStatsNotifierProvider.overrideWith(() => fakeStatsNotifier),
      ],
    );
    addTearDown(container.dispose);
  });

  Future<void> readyNotifier() async {
    container.read(activityNotifierProvider.notifier);
    await container.read(activityNotifierProvider.future);
  }

  group('add', () {
    test('success → AsyncData(null) and refreshes stats', () async {
      when(
        () => mockRepository.add(any()),
      ).thenAnswer((_) async => const Success<void>(null));
      await readyNotifier();

      final result = await container
          .read(activityNotifierProvider.notifier)
          .add(_activity());

      expect(result, isA<Success<void>>());
      expect(container.read(activityNotifierProvider), isA<AsyncData<void>>());
      expect(fakeStatsNotifier.refreshCalls, 1);
    });

    test('failure → AsyncError and does not refresh stats', () async {
      when(() => mockRepository.add(any())).thenAnswer(
        (_) async => const Failure<void>(DatabaseFailure('boom')),
      );
      await readyNotifier();

      final result = await container
          .read(activityNotifierProvider.notifier)
          .add(_activity());

      expect(result, isA<Failure<void>>());
      expect(container.read(activityNotifierProvider).hasError, isTrue);
      expect(fakeStatsNotifier.refreshCalls, 0);
    });
  });

  group('edit', () {
    test('success → AsyncData(null) and refreshes stats', () async {
      when(
        () => mockRepository.update(any()),
      ).thenAnswer((_) async => const Success<void>(null));
      await readyNotifier();

      final result = await container
          .read(activityNotifierProvider.notifier)
          .edit(_activity());

      expect(result, isA<Success<void>>());
      expect(container.read(activityNotifierProvider), isA<AsyncData<void>>());
      expect(fakeStatsNotifier.refreshCalls, 1);
    });

    test('failure → AsyncError and does not refresh stats', () async {
      when(() => mockRepository.update(any())).thenAnswer(
        (_) async => const Failure<void>(ValidationFailure('invalid')),
      );
      await readyNotifier();

      final result = await container
          .read(activityNotifierProvider.notifier)
          .edit(_activity());

      expect(result, isA<Failure<void>>());
      expect(container.read(activityNotifierProvider).hasError, isTrue);
      expect(fakeStatsNotifier.refreshCalls, 0);
    });
  });

  group('delete', () {
    test('success → AsyncData(null) and refreshes stats', () async {
      when(
        () => mockRepository.delete(any()),
      ).thenAnswer((_) async => const Success<void>(null));
      await readyNotifier();

      final result = await container
          .read(activityNotifierProvider.notifier)
          .delete('1');

      expect(result, isA<Success<void>>());
      expect(container.read(activityNotifierProvider), isA<AsyncData<void>>());
      expect(fakeStatsNotifier.refreshCalls, 1);
    });

    test('failure → AsyncError and does not refresh stats', () async {
      when(() => mockRepository.delete(any())).thenAnswer(
        (_) async => const Failure<void>(UnknownFailure('boom')),
      );
      await readyNotifier();

      final result = await container
          .read(activityNotifierProvider.notifier)
          .delete('1');

      expect(result, isA<Failure<void>>());
      expect(container.read(activityNotifierProvider).hasError, isTrue);
      expect(fakeStatsNotifier.refreshCalls, 0);
    });
  });

  group('getAll', () {
    test('delegates to repository with given filter and pagination', () async {
      const filter = ActivityFilter(search: 'math');
      const pagination = Pagination(page: 1, limit: 10);
      final activities = [_activity()];
      when(
        () => mockRepository.getAll(filter: filter, pagination: pagination),
      ).thenAnswer((_) async => Success<List<Activity>>(activities));
      await readyNotifier();

      final result = await container
          .read(activityNotifierProvider.notifier)
          .getAll(filter: filter, pagination: pagination);

      result.when(
        onSuccess: (value) => expect(value, activities),
        onFailure: (_) => fail('expected success'),
      );
      verify(
        () => mockRepository.getAll(filter: filter, pagination: pagination),
      ).called(1);
    });
  });

  group('count', () {
    test('delegates to repository with given filter', () async {
      const filter = ActivityFilter(disciplineId: 2);
      when(
        () => mockRepository.count(filter: filter),
      ).thenAnswer((_) async => const Success<int>(5));
      await readyNotifier();

      final result = await container
          .read(activityNotifierProvider.notifier)
          .count(filter: filter);

      result.when(
        onSuccess: (value) => expect(value, 5),
        onFailure: (_) => fail('expected success'),
      );
    });
  });

  group('getById', () {
    test('delegates to repository and returns matching activity', () async {
      final activity = _activity(id: 'abc');
      when(
        () => mockRepository.getById('abc'),
      ).thenAnswer((_) async => Success<Activity?>(activity));
      await readyNotifier();

      final result = await container
          .read(activityNotifierProvider.notifier)
          .getById('abc');

      result.when(
        onSuccess: (value) => expect(value, same(activity)),
        onFailure: (_) => fail('expected success'),
      );
    });

    test('repository failure → returns Failure', () async {
      when(() => mockRepository.getById('missing')).thenAnswer(
        (_) async => const Failure<Activity?>(DatabaseFailure('not found')),
      );
      await readyNotifier();

      final result = await container
          .read(activityNotifierProvider.notifier)
          .getById('missing');

      expect(result, isA<Failure<Activity?>>());
    });
  });

  group('createNew', () {
    test(
      'builds an Activity with the given fields and a generated id',
      () async {
        await readyNotifier();
        final reminders = [const TimeOfDay(hour: 8, minute: 0)];

        final activity = container
            .read(activityNotifierProvider.notifier)
            .createNew(
              title: 'Study',
              description: 'Review chapter 1',
              disciplineId: 3,
              tags: const ['urgent'],
              reminders: reminders,
              status: ActivityStatus.draft,
              category: 'exam',
              notes: 'bring calculator',
            );

        expect(activity.id, isNotEmpty);
        expect(activity.title, 'Study');
        expect(activity.description, 'Review chapter 1');
        expect(activity.disciplineId, 3);
        expect(activity.tags, ['urgent']);
        expect(activity.reminders, reminders);
        expect(activity.status, ActivityStatus.draft);
        expect(activity.category, 'exam');
        expect(activity.notes, 'bring calculator');
      },
    );
  });
}
