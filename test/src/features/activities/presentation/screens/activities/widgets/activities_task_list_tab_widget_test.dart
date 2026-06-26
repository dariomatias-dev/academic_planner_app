import 'dart:async';

import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';
import 'package:academic_planner/src/features/activities/presentation/providers/activity_notifier.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activities/widgets/activities_task_list_tab_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/activity_card/activity_card_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/empty_state_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/error_state_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/loading_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeActivityNotifier extends ActivityNotifier {
  @override
  Future<void> build() async {}
}

const _filter = ActivityFilter();

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

Future<ProviderContainer> _buildContainer({required int count}) async {
  final container = ProviderContainer(
    overrides: [
      activityNotifierProvider.overrideWith(_FakeActivityNotifier.new),
      activityCountProvider(_filter).overrideWith((ref) async => count),
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
  group('ActivitiesTaskListTabWidget', () {
    testWidgets('fetch pending → shows the loading state', (tester) async {
      final container = await _buildContainer(count: 0);
      addTearDown(container.dispose);

      final completer = Completer<Result<List<Activity>>>();

      await tester.pumpWidget(
        _harness(
          container,
          ActivitiesTaskListTabWidget(
            description: 'Tudo',
            emptyMessage: 'Nada aqui',
            filter: _filter,
            onFetch: ({required filter, required pagination}) =>
                completer.future,
          ),
        ),
      );

      expect(find.byType(LoadingStateWidget), findsOneWidget);

      completer.complete(const Success<List<Activity>>([]));
      await tester.pumpAndSettle();
    });

    testWidgets('fetch success with no activities → shows the empty state', (
      tester,
    ) async {
      final container = await _buildContainer(count: 0);
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _harness(
          container,
          ActivitiesTaskListTabWidget(
            description: 'Tudo',
            emptyMessage: 'Nada aqui',
            filter: _filter,
            onFetch: ({required filter, required pagination}) async {
              return const Success<List<Activity>>([]);
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(find.text('Nada aqui'), findsOneWidget);
    });

    testWidgets('fetch success with activities → renders one card each', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = await _buildContainer(count: 2);
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _harness(
          container,
          ActivitiesTaskListTabWidget(
            description: 'Tudo',
            emptyMessage: 'Nada aqui',
            filter: _filter,
            onFetch: ({required filter, required pagination}) async {
              return Success<List<Activity>>([
                _activity('a1'),
                _activity('a2'),
              ]);
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ActivityCardWidget), findsNWidgets(2));
      expect(find.byType(EmptyStateWidget), findsNothing);
    });

    testWidgets('fetch failure → shows the error state with a retry button', (
      tester,
    ) async {
      var attempts = 0;

      final container = await _buildContainer(count: 0);
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _harness(
          container,
          ActivitiesTaskListTabWidget(
            description: 'Tudo',
            emptyMessage: 'Nada aqui',
            filter: _filter,
            onFetch: ({required filter, required pagination}) async {
              attempts++;

              return const Failure<List<Activity>>(UnknownFailure('boom'));
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ErrorStateWidget), findsOneWidget);
      expect(attempts, 1);

      await tester.tap(find.text('Tentar novamente'));
      await tester.pumpAndSettle();

      expect(attempts, 2);
    });

    testWidgets('filter changes → refetches with the new filter', (
      tester,
    ) async {
      final container = await _buildContainer(count: 0);
      addTearDown(container.dispose);

      final calledFilters = <ActivityFilter>[];

      Widget build(ActivityFilter filter) {
        return _harness(
          container,
          ActivitiesTaskListTabWidget(
            description: 'Tudo',
            emptyMessage: 'Nada aqui',
            filter: filter,
            onFetch: ({required filter, required pagination}) async {
              calledFilters.add(filter);

              return const Success<List<Activity>>([]);
            },
          ),
        );
      }

      await tester.pumpWidget(build(_filter));
      await tester.pumpAndSettle();

      const newFilter = ActivityFilter(search: 'math');
      await tester.pumpWidget(build(newFilter));
      await tester.pumpAndSettle();

      expect(calledFilters, [_filter, newFilter]);
    });
  });
}
