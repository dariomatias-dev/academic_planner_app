import 'package:academic_planner/src/features/activities/presentation/screens/activity_form/widgets/fields/activity_form_category_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('ActivityFormCategorySelectorWidget', () {
    testWidgets('renders every category as a chip', (tester) async {
      await tester.pumpWidget(
        _harness(
          ActivityFormCategorySelectorWidget(
            categories: const ['Prova', 'Trabalho'],
            selectedCategory: null,
            onSelect: (_) {},
            onCreate: () {},
          ),
        ),
      );

      expect(find.text('Prova'), findsOneWidget);
      expect(find.text('Trabalho'), findsOneWidget);
    });

    testWidgets('tapping an unselected category selects it', (tester) async {
      String? selected;

      await tester.pumpWidget(
        _harness(
          ActivityFormCategorySelectorWidget(
            categories: const ['Prova'],
            selectedCategory: null,
            onSelect: (value) => selected = value,
            onCreate: () {},
          ),
        ),
      );

      await tester.tap(find.text('Prova'));

      expect(selected, 'Prova');
    });

    testWidgets('tapping the selected category deselects it (null)', (
      tester,
    ) async {
      String? selected = 'unset';

      await tester.pumpWidget(
        _harness(
          ActivityFormCategorySelectorWidget(
            categories: const ['Prova'],
            selectedCategory: 'Prova',
            onSelect: (value) => selected = value,
            onCreate: () {},
          ),
        ),
      );

      await tester.tap(find.text('Prova'));

      expect(selected, isNull);
    });

    testWidgets('tapping "+ Nova Categoria" calls onCreate', (tester) async {
      var createCalls = 0;

      await tester.pumpWidget(
        _harness(
          ActivityFormCategorySelectorWidget(
            categories: const [],
            selectedCategory: null,
            onSelect: (_) {},
            onCreate: () => createCalls++,
          ),
        ),
      );

      await tester.tap(find.text('+ Nova Categoria'));

      expect(createCalls, 1);
    });
  });
}
