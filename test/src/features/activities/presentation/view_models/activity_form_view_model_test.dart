import 'dart:convert';

import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity_stats.dart';
import 'package:academic_planner/src/features/activities/domain/repositories/activity_repository.dart';
import 'package:academic_planner/src/features/activities/presentation/providers/activity_stats_notifier.dart';
import 'package:academic_planner/src/features/activities/presentation/view_models/activity_form_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockActivityRepository extends Mock implements ActivityRepository {}

class _FakeActivityStatsNotifier extends ActivityStatsNotifier {
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
  Future<void> refresh() async {}
}

String _encodeDescription(String text) =>
    jsonEncode([{'insert': '$text\n'}]);

Activity _activity({
  String id = 'act-1',
  String title = 'Calculus Exam',
  String description = '',
  String? notes,
  int disciplineId = 15,
  String? category,
  DateTime? dueDate,
  List<String> tags = const [],
  List<TimeOfDay> reminders = const [],
  ActivityStatus status = ActivityStatus.pending,
}) => Activity(
  id: id,
  title: title,
  description: description.isEmpty ? _encodeDescription('') : description,
  notes: notes,
  disciplineId: disciplineId,
  category: category,
  dueDate: dueDate,
  tags: tags,
  reminders: reminders,
  status: status,
  createdAt: DateTime.parse('2024-01-01T00:00:00.000'),
  updatedAt: DateTime.parse('2024-01-01T00:00:00.000'),
);

void main() {
  late MockActivityRepository mockRepository;
  late ProviderContainer container;
  late ActivityFormViewModel sut;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(_activity());
  });

  setUp(() async {
    mockRepository = MockActivityRepository();
    container = ProviderContainer(
      overrides: [
        activityRepositoryProvider.overrideWithValue(mockRepository),
        activityStatsNotifierProvider.overrideWith(
          _FakeActivityStatsNotifier.new,
        ),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(activityNotifierProvider.notifier);
    await container.read(activityNotifierProvider.future);

    sut = ActivityFormViewModel(notifier);
    addTearDown(sut.dispose);
  });

  group('load - new activity', () {
    test('sets discipline from initialDisciplineId', () async {
      final result = await sut.load(
        activityId: null,
        initialDisciplineId: 15,
      );

      expect(result, isA<Success<void>>());
      expect(sut.discipline.value?.id, 15);
      expect(sut.initialActivity, isNull);
      expect(sut.canSave.value, isTrue);
    });

    test('without initialDisciplineId leaves discipline unset', () async {
      final result = await sut.load(
        activityId: null,
        initialDisciplineId: null,
      );

      expect(result, isA<Success<void>>());
      expect(sut.discipline.value, isNull);
      expect(sut.canSave.value, isTrue);
    });
  });

  group('load - existing activity', () {
    test('success populates fields and marks canSave false', () async {
      final activity = _activity(
        title: 'Study',
        description: _encodeDescription('Hello'),
        notes: 'Bring book',
        category: 'Homework',
        dueDate: DateTime(2024, 2),
        status: ActivityStatus.inProgress,
        tags: const ['urgent'],
        reminders: const [TimeOfDay(hour: 9, minute: 0)],
      );
      when(
        () => mockRepository.getById('act-1'),
      ).thenAnswer((_) async => Success<Activity?>(activity));

      final result = await sut.load(
        activityId: 'act-1',
        initialDisciplineId: null,
      );

      expect(result, isA<Success<void>>());
      expect(sut.initialActivity, activity);
      expect(sut.titleController.text, 'Study');
      expect(sut.notesController.text, 'Bring book');
      expect(sut.discipline.value?.id, 15);
      expect(sut.dueDate.value, DateTime(2024, 2));
      expect(sut.status.value, ActivityStatus.inProgress);
      expect(sut.category.value, 'Homework');
      expect(sut.tags.value, ['urgent']);
      expect(sut.reminders.value, [const TimeOfDay(hour: 9, minute: 0)]);
      expect(sut.isLoading.value, isFalse);
      expect(sut.canSave.value, isFalse);
    });

    test('activity not found keeps initialActivity null', () async {
      when(
        () => mockRepository.getById('missing'),
      ).thenAnswer((_) async => const Success<Activity?>(null));

      final result = await sut.load(
        activityId: 'missing',
        initialDisciplineId: null,
      );

      expect(result, isA<Success<void>>());
      expect(sut.initialActivity, isNull);
      expect(sut.isLoading.value, isFalse);
    });

    test('repository failure returns Failure', () async {
      when(() => mockRepository.getById('act-1')).thenAnswer(
        (_) async => const Failure<Activity?>(DatabaseFailure('not found')),
      );

      final result = await sut.load(
        activityId: 'act-1',
        initialDisciplineId: null,
      );

      expect(result, isA<Failure<void>>());
      expect(sut.isLoading.value, isFalse);
    });

    test('malformed description JSON is handled without throwing', () async {
      final activity = _activity(description: 'not-json');
      when(
        () => mockRepository.getById('act-1'),
      ).thenAnswer((_) async => Success<Activity?>(activity));

      final result = await sut.load(
        activityId: 'act-1',
        initialDisciplineId: null,
      );

      expect(result, isA<Success<void>>());
      expect(sut.initialActivity, activity);
    });
  });

  group('save', () {
    test('without initial activity creates and adds a new one', () async {
      when(
        () => mockRepository.add(any()),
      ).thenAnswer((_) async => const Success<void>(null));
      await sut.load(activityId: null, initialDisciplineId: 15);
      sut.titleController.text = 'New title';

      final result = await sut.save();

      expect(result, isA<Success<void>>());
      final captured =
          verify(() => mockRepository.add(captureAny())).captured.single
              as Activity;
      expect(captured.title, 'New title');
      expect(captured.disciplineId, 15);
    });

    test('with initial activity updates it via the notifier', () async {
      final activity = _activity();
      when(
        () => mockRepository.getById('act-1'),
      ).thenAnswer((_) async => Success<Activity?>(activity));
      when(
        () => mockRepository.update(any()),
      ).thenAnswer((_) async => const Success<void>(null));
      await sut.load(activityId: 'act-1', initialDisciplineId: null);
      sut.titleController.text = 'Updated title';

      final result = await sut.save();

      expect(result, isA<Success<void>>());
      final captured =
          verify(() => mockRepository.update(captureAny())).captured.single
              as Activity;
      expect(captured.id, 'act-1');
      expect(captured.title, 'Updated title');
    });

    test('propagates repository failure on create', () async {
      when(() => mockRepository.add(any())).thenAnswer(
        (_) async => const Failure<void>(DatabaseFailure('insert failed')),
      );
      await sut.load(activityId: null, initialDisciplineId: 15);
      sut.titleController.text = 'New title';

      final result = await sut.save();

      expect(result, isA<Failure<void>>());
    });
  });

  group('field setters', () {
    setUp(() async {
      await sut.load(activityId: null, initialDisciplineId: null);
    });

    test('setDiscipline updates discipline', () {
      final discipline = adsDisciplines.firstWhere((d) => d.id == 15);

      sut.setDiscipline(discipline);

      expect(sut.discipline.value, discipline);
    });

    test('setStatus updates status', () {
      sut.setStatus(ActivityStatus.completed);

      expect(sut.status.value, ActivityStatus.completed);
    });

    test('setCategory updates category', () {
      sut.setCategory('Homework');

      expect(sut.category.value, 'Homework');
    });

    test('setDueDate updates dueDate', () {
      final date = DateTime(2024, 3);

      sut.setDueDate(date);

      expect(sut.dueDate.value, date);
    });

    test('toggleTag adds and removes tags', () {
      sut.toggleTag('urgent', value: true);

      expect(sut.tags.value, ['urgent']);

      sut.toggleTag('urgent');

      expect(sut.tags.value, isEmpty);
    });

    test('addReminder ignores duplicate reminders', () {
      const time = TimeOfDay(hour: 8, minute: 0);

      sut
        ..addReminder(time)
        ..addReminder(time);

      expect(sut.reminders.value, [time]);
    });

    test('removeReminder removes a matching reminder', () {
      const time = TimeOfDay(hour: 8, minute: 0);

      sut
        ..addReminder(time)
        ..removeReminder(time);

      expect(sut.reminders.value, isEmpty);
    });
  });

  group('hasChanges', () {
    test('is true for a brand-new activity with no edits', () async {
      await sut.load(activityId: null, initialDisciplineId: null);

      expect(sut.hasChanges(), isTrue);
    });

    test('is false right after loading an unmodified activity', () async {
      final activity = _activity();
      when(
        () => mockRepository.getById('act-1'),
      ).thenAnswer((_) async => Success<Activity?>(activity));
      await sut.load(activityId: 'act-1', initialDisciplineId: null);

      expect(sut.hasChanges(), isFalse);
    });

    test('is true after editing the title of a loaded activity', () async {
      final activity = _activity();
      when(
        () => mockRepository.getById('act-1'),
      ).thenAnswer((_) async => Success<Activity?>(activity));
      await sut.load(activityId: 'act-1', initialDisciplineId: null);

      sut.titleController.text = 'Changed title';

      expect(sut.hasChanges(), isTrue);
    });

    test(
      'ignores time-of-day differences within the same calendar day',
      () async {
        final activity = _activity(dueDate: DateTime(2024, 2, 1, 8));
        when(
          () => mockRepository.getById('act-1'),
        ).thenAnswer((_) async => Success<Activity?>(activity));
        await sut.load(activityId: 'act-1', initialDisciplineId: null);

        sut.setDueDate(DateTime(2024, 2, 1, 20));

        expect(sut.hasChanges(), isFalse);
      },
    );

    test('detects a changed due date on a different day', () async {
      final activity = _activity(dueDate: DateTime(2024, 2));
      when(
        () => mockRepository.getById('act-1'),
      ).thenAnswer((_) async => Success<Activity?>(activity));
      await sut.load(activityId: 'act-1', initialDisciplineId: null);

      sut.setDueDate(DateTime(2024, 2, 2));

      expect(sut.hasChanges(), isTrue);
    });
  });
}
