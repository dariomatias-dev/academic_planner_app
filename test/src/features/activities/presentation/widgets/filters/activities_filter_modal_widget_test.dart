import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/filters/activities_filter_modal_widget.dart';
import 'package:academic_planner/src/features/categories/di/category_providers.dart';
import 'package:academic_planner/src/features/categories/domain/entities/category.dart';
import 'package:academic_planner/src/features/categories/presentation/providers/category_notifier.dart';
import 'package:academic_planner/src/features/tags/di/tag_providers.dart';
import 'package:academic_planner/src/features/tags/domain/entities/tag.dart';
import 'package:academic_planner/src/features/tags/presentation/providers/tag_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeCategoryNotifier extends CategoryNotifier {
  @override
  Future<List<Category>> build() async => [];
}

class _FakeTagNotifier extends TagNotifier {
  @override
  Future<List<Tag>> build() async => [];
}

Future<ProviderContainer> _buildContainer({
  ActivityFilter? initialFilter,
}) async {
  final container = ProviderContainer(
    overrides: [
      categoryNotifierProvider.overrideWith(_FakeCategoryNotifier.new),
      tagNotifierProvider.overrideWith(_FakeTagNotifier.new),
    ],
  );

  if (initialFilter != null) {
    container.read(activityFilterNotifierProvider.notifier).filter =
        initialFilter;
  }

  await container.read(categoryNotifierProvider.future);
  await container.read(tagNotifierProvider.future);

  return container;
}

Widget _harness(ProviderContainer container) {
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
                  builder: (_) => const ActivitiesFilterModalWidget(),
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
  group('ActivitiesFilterModalWidget', () {
    testWidgets('no current filter → sections show their placeholders', (
      tester,
    ) async {
      final container = await _buildContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Nenhuma disciplina'), findsOneWidget);
      expect(find.text('Nenhuma categoria'), findsOneWidget);
      expect(find.text('Nenhuma tag'), findsOneWidget);
    });

    testWidgets('current filter set → sections reflect its values', (
      tester,
    ) async {
      final container = await _buildContainer(
        initialFilter: const ActivityFilter(
          disciplineId: 14,
          category: 'Prova',
          tags: ['urgente'],
        ),
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(
        find.text('Algoritmos e Lógica de Programação'),
        findsOneWidget,
      );
      expect(find.text('Prova'), findsOneWidget);
      expect(find.text('urgente'), findsOneWidget);
    });

    testWidgets('tapping "Limpar" resets every section to its placeholder', (
      tester,
    ) async {
      final container = await _buildContainer(
        initialFilter: const ActivityFilter(
          disciplineId: 14,
          category: 'Prova',
          tags: ['urgente'],
        ),
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Limpar'));
      await tester.pumpAndSettle();

      expect(find.text('Nenhuma disciplina'), findsOneWidget);
      expect(find.text('Nenhuma categoria'), findsOneWidget);
      expect(find.text('Nenhuma tag'), findsOneWidget);
    });

    testWidgets(
      'tapping "Aplicar Filtros" writes the filter and keeps the existing '
      'search term',
      (tester) async {
        final container = await _buildContainer(
          initialFilter: const ActivityFilter(search: 'calculo'),
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

        final applied = container.read(activityFilterNotifierProvider);
        expect(applied.disciplineId, 14);
        expect(applied.search, 'calculo');
        expect(find.text('open'), findsOneWidget);
        expect(find.text('Aplicar Filtros'), findsNothing);
      },
    );
  });
}
