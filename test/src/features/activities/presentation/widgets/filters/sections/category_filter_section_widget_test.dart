import 'package:academic_planner/src/features/activities/presentation/widgets/filters/sections/category_filter_section_widget.dart';
import 'package:academic_planner/src/features/categories/di/category_providers.dart';
import 'package:academic_planner/src/features/categories/domain/entities/category.dart';
import 'package:academic_planner/src/features/categories/presentation/providers/category_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeCategoryNotifier extends CategoryNotifier {
  _FakeCategoryNotifier(this._categories);

  final List<Category> _categories;

  @override
  Future<List<Category>> build() async => _categories;
}

Future<ProviderContainer> _buildContainer(List<String> categories) async {
  final container = ProviderContainer(
    overrides: [
      categoryNotifierProvider.overrideWith(
        () => _FakeCategoryNotifier(
          categories.map((name) => Category(name: name)).toList(),
        ),
      ),
    ],
  );

  await container.read(categoryNotifierProvider.future);

  return container;
}

Widget _harness(ProviderContainer container, Widget child) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

void main() {
  group('CategoryFilterSectionWidget', () {
    testWidgets('no value → shows the placeholder', (tester) async {
      final container = await _buildContainer(['Prova']);
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _harness(
          container,
          CategoryFilterSectionWidget(value: null, onChanged: (_) {}),
        ),
      );

      expect(find.text('Nenhuma categoria'), findsOneWidget);
      expect(find.text('Toque para selecionar'), findsOneWidget);
    });

    testWidgets('value set → shows it and "Filtro ativo"', (tester) async {
      final container = await _buildContainer(['Prova']);
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _harness(
          container,
          CategoryFilterSectionWidget(value: 'Prova', onChanged: (_) {}),
        ),
      );

      expect(find.text('Prova'), findsOneWidget);
      expect(find.text('Filtro ativo'), findsOneWidget);
    });

    testWidgets('selecting a category in the modal calls onChanged and '
        'closes it', (tester) async {
      final container = await _buildContainer(['Prova', 'Trabalho']);
      addTearDown(container.dispose);

      String? selected = 'unset';

      await tester.pumpWidget(
        _harness(
          container,
          CategoryFilterSectionWidget(
            value: null,
            onChanged: (value) => selected = value,
          ),
        ),
      );

      await tester.tap(find.text('Nenhuma categoria'));
      await tester.pumpAndSettle();

      expect(find.text('Filtrar por Categoria'), findsOneWidget);

      await tester.tap(find.text('Trabalho'));
      await tester.pumpAndSettle();

      expect(selected, 'Trabalho');
      expect(find.text('Filtrar por Categoria'), findsNothing);
    });

    testWidgets('selecting the already-active category clears it', (
      tester,
    ) async {
      final container = await _buildContainer(['Prova']);
      addTearDown(container.dispose);

      String? selected = 'unset';

      await tester.pumpWidget(
        _harness(
          container,
          CategoryFilterSectionWidget(
            value: 'Prova',
            onChanged: (value) => selected = value,
          ),
        ),
      );

      await tester.tap(find.text('Prova').first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Prova').last);
      await tester.pumpAndSettle();

      expect(selected, isNull);
    });

    testWidgets('no categories registered → shows the empty state', (
      tester,
    ) async {
      final container = await _buildContainer([]);
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _harness(
          container,
          CategoryFilterSectionWidget(value: null, onChanged: (_) {}),
        ),
      );

      await tester.tap(find.text('Nenhuma categoria'));
      await tester.pumpAndSettle();

      expect(
        find.text('Não há categorias cadastradas para filtragem.'),
        findsOneWidget,
      );
    });
  });
}
