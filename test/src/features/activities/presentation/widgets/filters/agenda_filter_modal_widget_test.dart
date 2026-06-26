import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/filters/agenda_filter_modal_widget.dart';
import 'package:academic_planner/src/features/calendar/di/calendar_providers.dart';
import 'package:academic_planner/src/features/calendar/presentation/providers/agenda_notifier.dart';
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

class _FakeAgendaNotifier extends AgendaNotifier {
  _FakeAgendaNotifier({this.onFetchData});

  final Future<void> Function(ActivityFilter? filter)? onFetchData;

  @override
  Future<AgendaState> build() async => AgendaState();

  @override
  Future<void> fetchData({ActivityFilter? filter}) async {
    await onFetchData?.call(filter);
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

Future<ProviderContainer> _buildContainer({
  Future<void> Function(ActivityFilter? filter)? onFetchData,
}) async {
  final container = ProviderContainer(
    overrides: [
      agendaNotifierProvider.overrideWith(
        () => _FakeAgendaNotifier(onFetchData: onFetchData),
      ),
      categoryNotifierProvider.overrideWith(_FakeCategoryNotifier.new),
      tagNotifierProvider.overrideWith(_FakeTagNotifier.new),
    ],
  );

  await container.read(agendaNotifierProvider.future);
  await container.read(categoryNotifierProvider.future);
  await container.read(tagNotifierProvider.future);

  return container;
}

Widget _harness(ProviderContainer container, {ActivityFilter? initialFilter}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () async {
                await showModalBottomSheet<void>(
                  context: context,
                  builder: (_) =>
                      AgendaFilterModalWidget(initialFilter: initialFilter),
                );
              },
              child: const Text('open'),
            );
          },
        ),
      ),
    ),
  );
}

void main() {
  group('AgendaFilterModalWidget', () {
    testWidgets('no initial filter → sections show their placeholders', (
      tester,
    ) async {
      final container = await _buildContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Filtros da Agenda'), findsOneWidget);
      expect(find.text('Nenhuma disciplina'), findsOneWidget);
      expect(find.text('Nenhuma categoria'), findsOneWidget);
      expect(find.text('Nenhuma tag'), findsOneWidget);
    });

    testWidgets('initial filter set → sections reflect its values', (
      tester,
    ) async {
      final container = await _buildContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _harness(
          container,
          initialFilter: const ActivityFilter(
            disciplineId: 14,
            category: 'Prova',
            tags: ['urgente'],
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(
        find.text('Algoritmos e Lógica de Programação'),
        findsOneWidget,
      );
      expect(find.text('Prova'), findsOneWidget);
      expect(find.text('urgente'), findsOneWidget);
    });

    testWidgets('tapping "Limpar" resets every section', (tester) async {
      final container = await _buildContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _harness(
          container,
          initialFilter: const ActivityFilter(
            disciplineId: 14,
            category: 'Prova',
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Limpar'));
      await tester.pumpAndSettle();

      expect(find.text('Nenhuma disciplina'), findsOneWidget);
      expect(find.text('Nenhuma categoria'), findsOneWidget);
    });

    testWidgets(
      'tapping "Aplicar Filtros" fetches with the selected filter and '
      'closes the modal',
      (tester) async {
        ActivityFilter? fetchedFilter;

        final container = await _buildContainer(
          onFetchData: (filter) async => fetchedFilter = filter,
        );
        addTearDown(container.dispose);

        await tester.pumpWidget(_harness(container));
        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Nenhuma disciplina'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Algoritmos e Lógica de Programação'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Aplicar Filtros'));
        await tester.pumpAndSettle();

        expect(fetchedFilter?.disciplineId, 14);
        expect(find.text('open'), findsOneWidget);
        expect(find.text('Aplicar Filtros'), findsNothing);
      },
    );
  });
}
