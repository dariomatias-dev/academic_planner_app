import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/domain/repositories/activity_repository.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';
import 'package:academic_planner/src/features/calendar/di/calendar_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockActivityRepository extends Mock implements ActivityRepository {}

Activity _activity({String id = '1', DateTime? dueDate}) => Activity(
  id: id,
  title: 'Title',
  description: 'Description',
  disciplineId: 1,
  tags: const [],
  reminders: const [],
  status: ActivityStatus.pending,
  dueDate: dueDate,
);

void main() {
  late MockActivityRepository mockRepository;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(_activity());
    registerFallbackValue(const ActivityFilter());
  });

  setUp(() {
    mockRepository = MockActivityRepository();
    container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        activityRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);
  });

  void stubGetAll(ActivityFilter? filter, Result<List<Activity>> result) {
    when(
      () => mockRepository.getAll(filter: filter),
    ).thenAnswer((_) async => result);
  }

  Future<void> readyActivityNotifier() async {
    container.read(activityNotifierProvider.notifier);
    await container.read(activityNotifierProvider.future);
  }

  group('build', () {
    test('loads activities and keeps only those with a dueDate', () async {
      final withDate = _activity(dueDate: DateTime(2026, 1, 10));
      final withoutDate = _activity(id: '2');
      await readyActivityNotifier();
      stubGetAll(null, Success<List<Activity>>([withDate, withoutDate]));

      final state = await container.read(agendaNotifierProvider.future);

      expect(state.activities, [withDate]);
    });

    test('repository failure → notifier throws', () async {
      await readyActivityNotifier();
      stubGetAll(null, const Failure<List<Activity>>(DatabaseFailure('boom')));

      await expectLater(
        container.read(agendaNotifierProvider.future),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('fetchData', () {
    test('success → updates activities and stores filter', () async {
      await readyActivityNotifier();
      stubGetAll(null, const Success<List<Activity>>([]));
      await container.read(agendaNotifierProvider.future);

      const filter = ActivityFilter(search: 'math');
      final activity = _activity(dueDate: DateTime(2026, 2));
      stubGetAll(filter, Success<List<Activity>>([activity]));

      await container
          .read(agendaNotifierProvider.notifier)
          .fetchData(filter: filter);

      final state = container.read(agendaNotifierProvider).value!;
      expect(state.activities, [activity]);
      expect(state.filter, filter);
    });

    test('failure → AsyncError', () async {
      await readyActivityNotifier();
      stubGetAll(null, const Success<List<Activity>>([]));
      await container.read(agendaNotifierProvider.future);

      stubGetAll(null, const Failure<List<Activity>>(UnknownFailure('boom')));

      await container.read(agendaNotifierProvider.notifier).fetchData();

      expect(container.read(agendaNotifierProvider).hasError, isTrue);
    });
  });

  group('updateDisplayDate', () {
    test('changes the displayDate when month differs', () async {
      await readyActivityNotifier();
      stubGetAll(null, const Success<List<Activity>>([]));
      await container.read(agendaNotifierProvider.future);

      container
          .read(agendaNotifierProvider.notifier)
          .updateDisplayDate(DateTime(2030, 6));

      expect(
        container.read(agendaNotifierProvider).value!.displayDate,
        DateTime(2030, 6),
      );
    });
  });

  group('updateSelectedDate', () {
    test('changes the selectedDate', () async {
      await readyActivityNotifier();
      stubGetAll(null, const Success<List<Activity>>([]));
      await container.read(agendaNotifierProvider.future);

      container
          .read(agendaNotifierProvider.notifier)
          .updateSelectedDate(DateTime(2030, 6, 2));

      expect(
        container.read(agendaNotifierProvider).value!.selectedDate,
        DateTime(2030, 6, 2),
      );
    });
  });

  group('clearFilter', () {
    test('removes the stored filter', () async {
      await readyActivityNotifier();
      stubGetAll(null, const Success<List<Activity>>([]));
      await container.read(agendaNotifierProvider.future);

      const filter = ActivityFilter(search: 'math');
      stubGetAll(filter, const Success<List<Activity>>([]));
      await container
          .read(agendaNotifierProvider.notifier)
          .fetchData(filter: filter);
      expect(container.read(agendaNotifierProvider).value!.filter, filter);

      container.read(agendaNotifierProvider.notifier).clearFilter();

      expect(container.read(agendaNotifierProvider).value!.filter, isNull);
    });
  });
}
