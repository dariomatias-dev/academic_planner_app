import 'dart:async';

import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';
import 'package:academic_planner/src/features/calendar/di/calendar_providers.dart';
import 'package:academic_planner/src/features/calendar/presentation/providers/agenda_notifier.dart';
import 'package:academic_planner/src/features/calendar/presentation/screens/agenda/agenda_screen.dart';
import 'package:academic_planner/src/features/calendar/presentation/view_models/agenda_state.dart';
import 'package:academic_planner/src/features/categories/di/category_providers.dart';
import 'package:academic_planner/src/features/categories/domain/entities/category.dart';
import 'package:academic_planner/src/features/categories/presentation/providers/category_notifier.dart';
import 'package:academic_planner/src/features/tags/di/tag_providers.dart';
import 'package:academic_planner/src/features/tags/domain/entities/tag.dart';
import 'package:academic_planner/src/features/tags/presentation/providers/tag_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class _FakeAgendaNotifier extends AgendaNotifier {
  _FakeAgendaNotifier({this.build_, this.onFetchData});

  final Future<AgendaState> Function()? build_;
  final Future<void> Function({ActivityFilter? filter})? onFetchData;

  @override
  Future<AgendaState> build() {
    return build_?.call() ?? Future.value(AgendaState());
  }

  @override
  Future<void> fetchData({ActivityFilter? filter}) async {
    if (onFetchData != null) {
      await onFetchData!(filter: filter);

      return;
    }

    state = AsyncData(AgendaState(filter: filter));
  }

  @override
  void updateDisplayDate(DateTime date) {
    final currentState = state.value;
    if (currentState == null) return;

    if (date.month != currentState.displayDate.month ||
        date.year != currentState.displayDate.year) {
      state = AsyncData(currentState.copyWith(displayDate: date));
    }
  }

  @override
  void updateSelectedDate(DateTime date) {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncData(currentState.copyWith(selectedDate: date));
  }
}

class _FakeCategoryNotifier extends CategoryNotifier {
  @override
  Future<List<Category>> build() async => [];
}

class _FakeTagNotifier extends TagNotifier {
  @override
  Future<List<Tag>> build() async => [];
}

Activity _activity({DateTime? dueDate}) => Activity(
  id: 'a1',
  title: 'Prova de Calculo',
  description: 'desc',
  disciplineId: 14,
  dueDate: dueDate,
  tags: const [],
  reminders: const [],
  status: ActivityStatus.pending,
  createdAt: DateTime(2025),
  updatedAt: DateTime(2025),
);

Future<ProviderContainer> _buildContainer({
  Future<AgendaState> Function()? build_,
  Future<void> Function({ActivityFilter? filter})? onFetchData,
}) async {
  final container = ProviderContainer(
    overrides: [
      agendaNotifierProvider.overrideWith(
        () => _FakeAgendaNotifier(build_: build_, onFetchData: onFetchData),
      ),
      categoryNotifierProvider.overrideWith(_FakeCategoryNotifier.new),
      tagNotifierProvider.overrideWith(_FakeTagNotifier.new),
    ],
  );

  await container.read(categoryNotifierProvider.future);
  await container.read(tagNotifierProvider.future);

  return container;
}

Widget _harness(ProviderContainer container) {
  return UncontrolledProviderScope(
    container: container,
    child: const MaterialApp(home: AgendaScreen()),
  );
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
  });

  group('AgendaScreen', () {
    testWidgets('build pending → shows the loading state', (tester) async {
      final completer = Completer<AgendaState>();

      final container = await _buildContainer(build_: () => completer.future);
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(AgendaState());
      await tester.pumpAndSettle();
    });

    testWidgets('build failure → shows the error state', (tester) async {
      final container = await _buildContainer(
        build_: () async => throw Exception('boom'),
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      expect(
        find.text('Não foi possível carregar sua agenda.'),
        findsOneWidget,
      );
    });

    testWidgets('build success → renders the month header and the '
        'calendar', (tester) async {
      final container = await _buildContainer(
        build_: () async => AgendaState(
          displayDate: DateTime(2025, 3, 10),
          activities: [_activity(dueDate: DateTime(2025, 3, 10))],
        ),
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      expect(find.text('Minha Agenda'), findsOneWidget);
      expect(find.byType(SfCalendar), findsOneWidget);
    });

    testWidgets('tapping the filter icon opens the filter modal', (
      tester,
    ) async {
      final container = await _buildContainer(
        build_: () async => AgendaState(),
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();

      expect(find.text('Filtros da Agenda'), findsOneWidget);
    });
  });
}
