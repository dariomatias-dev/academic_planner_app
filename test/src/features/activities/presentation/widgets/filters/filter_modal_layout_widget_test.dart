import 'package:academic_planner/src/features/activities/presentation/widgets/filters/filter_modal_layout_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('FilterModalLayoutWidget', () {
    testWidgets('renders the title and the children', (tester) async {
      await tester.pumpWidget(
        _harness(
          FilterModalLayoutWidget(
            title: 'Filtros',
            onClear: () {},
            onApply: () {},
            children: const [Text('conteúdo do filtro')],
          ),
        ),
      );

      expect(find.text('Filtros'), findsOneWidget);
      expect(find.text('conteúdo do filtro'), findsOneWidget);
      expect(find.text('Limpar'), findsOneWidget);
      expect(find.text('Aplicar Filtros'), findsOneWidget);
    });

    testWidgets('tapping "Limpar" calls onClear', (tester) async {
      var clearCalls = 0;

      await tester.pumpWidget(
        _harness(
          FilterModalLayoutWidget(
            title: 'Filtros',
            onClear: () => clearCalls++,
            onApply: () {},
            children: const [],
          ),
        ),
      );

      await tester.tap(find.text('Limpar'));

      expect(clearCalls, 1);
    });

    testWidgets('tapping "Aplicar Filtros" calls onApply', (tester) async {
      var applyCalls = 0;

      await tester.pumpWidget(
        _harness(
          FilterModalLayoutWidget(
            title: 'Filtros',
            onClear: () {},
            onApply: () => applyCalls++,
            children: const [],
          ),
        ),
      );

      await tester.tap(find.text('Aplicar Filtros'));

      expect(applyCalls, 1);
    });
  });
}
