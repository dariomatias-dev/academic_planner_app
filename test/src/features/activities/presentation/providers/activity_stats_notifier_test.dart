import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/domain/repositories/activity_repository.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockActivityRepository extends Mock implements ActivityRepository {}

void main() {
  late MockActivityRepository mockRepository;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(const ActivityFilter());
  });

  setUp(() {
    mockRepository = MockActivityRepository();
    container = ProviderContainer(
      overrides: [
        activityRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);
  });

  void mockCounts({
    required int total,
    required int active,
    required int completed,
    required int urgent,
  }) {
    when(() => mockRepository.count(filter: any(named: 'filter'))).thenAnswer(
      (invocation) async {
        final filter = invocation.namedArguments[#filter] as ActivityFilter?;

        if (filter == null) return Success<int>(total);
        if (filter.statuses?.contains(ActivityStatus.completed) ?? false) {
          return Success<int>(completed);
        }
        if (filter.dueBefore != null) return Success<int>(urgent);

        return Success<int>(active);
      },
    );
  }

  group('build', () {
    test('aggregates counts from the repository into ActivityStats', () async {
      mockCounts(total: 10, active: 6, completed: 4, urgent: 2);

      final stats = await container.read(activityStatsNotifierProvider.future);

      expect(stats.total, 10);
      expect(stats.active, 6);
      expect(stats.completed, 4);
      expect(stats.urgent, 2);
      expect(stats.progress, 0.4);
    });

    test('total zero → progress is 0.0 instead of NaN', () async {
      mockCounts(total: 0, active: 0, completed: 0, urgent: 0);

      final stats = await container.read(activityStatsNotifierProvider.future);

      expect(stats.total, 0);
      expect(stats.progress, 0.0);
    });

    test(
      'a failing count falls back to 0 without failing the others',
      () async {
        when(
          () => mockRepository.count(filter: any(named: 'filter')),
        ).thenAnswer(
          (invocation) async {
            final filter =
                invocation.namedArguments[#filter] as ActivityFilter?;

            if (filter == null) {
              return const Failure<int>(DatabaseFailure('boom'));
            }
            if (filter.statuses?.contains(ActivityStatus.completed) ?? false) {
              return const Success<int>(4);
            }
            if (filter.dueBefore != null) return const Success<int>(2);

            return const Success<int>(6);
          },
        );

        final stats = await container.read(
          activityStatsNotifierProvider.future,
        );

        expect(stats.total, 0);
        expect(stats.active, 6);
        expect(stats.completed, 4);
        expect(stats.urgent, 2);
      },
    );
  });

  group('refresh', () {
    test('reloads stats and updates state with new values', () async {
      mockCounts(total: 10, active: 6, completed: 4, urgent: 2);
      await container.read(activityStatsNotifierProvider.future);

      mockCounts(total: 20, active: 12, completed: 8, urgent: 1);
      await container.read(activityStatsNotifierProvider.notifier).refresh();

      final stats = container.read(activityStatsNotifierProvider).value!;
      expect(stats.total, 20);
      expect(stats.active, 12);
      expect(stats.completed, 8);
      expect(stats.urgent, 1);
    });

    test('called while already loading → does not reload', () async {
      mockCounts(total: 10, active: 6, completed: 4, urgent: 2);

      final notifier = container.read(activityStatsNotifierProvider.notifier);
      final firstRefresh = notifier.refresh();
      final secondRefresh = notifier.refresh();

      await Future.wait([firstRefresh, secondRefresh]);

      verify(
        () => mockRepository.count(filter: any(named: 'filter')),
      ).called(4);
    });
  });
}
