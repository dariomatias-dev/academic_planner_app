import 'dart:async';

import 'package:academic_planner/src/core/domain/entities/pagination.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';
import 'package:academic_planner/src/features/activities/presentation/providers/activity_notifier.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/activity_card/activity_card_widget.dart';
import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_details/widgets/discipline_details_activities_tab_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeActivityNotifier extends ActivityNotifier {
  _FakeActivityNotifier({
    this.all = const [],
    this.active = const [],
    this.completed = const [],
    this.urgent = const [],
    this.onGetAll,
  });

  final List<Activity> all;
  final List<Activity> active;
  final List<Activity> completed;
  final List<Activity> urgent;
  final Future<Result<List<Activity>>> Function()? onGetAll;

  @override
  Future<void> build() async {}

  @override
  Future<Result<List<Activity>>> getAll({
    ActivityFilter? filter,
    Pagination? pagination,
  }) async {
    if (onGetAll != null) return onGetAll!();

    if (filter?.statuses == null) return Success<List<Activity>>(all);
    if (filter!.endDate != null) return Success<List<Activity>>(urgent);
    if (filter.statuses!.contains(ActivityStatus.completed)) {
      return Success<List<Activity>>(completed);
    }

    return Success<List<Activity>>(active);
  }
}

Activity _activity(String id) => Activity(
  id: id,
  title: 'Activity $id',
  description: 'desc',
  disciplineId: 14,
  tags: const [],
  reminders: const [],
  status: ActivityStatus.pending,
  createdAt: DateTime(2025),
  updatedAt: DateTime(2025),
);

Future<ProviderContainer> _buildContainer(
  _FakeActivityNotifier notifier,
) async {
  final container = ProviderContainer(
    overrides: [
      activityNotifierProvider.overrideWith(() => notifier),
    ],
  );

  await container.read(activityNotifierProvider.future);

  return container;
}

Widget _harness(ProviderContainer container, Widget child) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

void main() {
  group('DisciplineDetailsActivitiesTabWidget', () {
    testWidgets('fetch pending → shows the loading state', (tester) async {
      final completer = Completer<Result<List<Activity>>>();

      final container = await _buildContainer(
        _FakeActivityNotifier(onGetAll: () => completer.future),
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _harness(
          container,
          const DisciplineDetailsActivitiesTabWidget(disciplineId: 14),
        ),
      );

      expect(find.text('Obtendo atividades...'), findsOneWidget);

      completer.complete(const Success<List<Activity>>([]));
      await tester.pumpAndSettle();
    });

    testWidgets('fetch failure → shows the error state', (tester) async {
      final container = await _buildContainer(
        _FakeActivityNotifier(
          onGetAll: () async => throw Exception('boom'),
        ),
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _harness(
          container,
          const DisciplineDetailsActivitiesTabWidget(disciplineId: 14),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Erro ao obter as atividades'), findsOneWidget);
    });

    testWidgets('no activities → shows the empty state', (tester) async {
      final container = await _buildContainer(_FakeActivityNotifier());
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _harness(
          container,
          const DisciplineDetailsActivitiesTabWidget(disciplineId: 14),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sem atividades'), findsOneWidget);
      expect(find.text('Criar Atividade'), findsOneWidget);
    });

    testWidgets('has activities → shows metrics, priority and the full '
        'list', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = await _buildContainer(
        _FakeActivityNotifier(
          all: [_activity('a1'), _activity('a2'), _activity('a3')],
          active: [_activity('a1'), _activity('a2')],
          completed: [_activity('a3')],
          urgent: [_activity('a1')],
        ),
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _harness(
          container,
          const DisciplineDetailsActivitiesTabWidget(disciplineId: 14),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sem atividades'), findsNothing);
      expect(find.text('PRIORIDADE'), findsOneWidget);
      expect(find.text('TODAS AS ATIVIDADES'), findsOneWidget);
      expect(find.byType(ActivityCardWidget), findsNWidgets(5));
    });
  });
}
