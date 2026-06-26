import 'package:academic_planner/src/features/activities/presentation/widgets/filters/sections/discipline_filter_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('DisciplineFilterSectionWidget', () {
    testWidgets('no selection → shows the placeholder', (tester) async {
      await tester.pumpWidget(
        _harness(
          DisciplineFilterSectionWidget(selectedId: null, onSelected: (_) {}),
        ),
      );

      expect(find.text('Nenhuma disciplina'), findsOneWidget);
      expect(find.text('Toque para selecionar'), findsOneWidget);
    });

    testWidgets('selection set → shows the discipline name', (tester) async {
      await tester.pumpWidget(
        _harness(
          DisciplineFilterSectionWidget(selectedId: 14, onSelected: (_) {}),
        ),
      );

      expect(
        find.text('Algoritmos e Lógica de Programação'),
        findsOneWidget,
      );
      expect(find.text('Filtro ativo'), findsOneWidget);
    });

    testWidgets('tapping the field opens the discipline picker modal', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          DisciplineFilterSectionWidget(selectedId: null, onSelected: (_) {}),
        ),
      );

      await tester.tap(find.text('Nenhuma disciplina'));
      await tester.pumpAndSettle();

      expect(find.text('Filtrar por Disciplina'), findsOneWidget);
    });
  });
}
