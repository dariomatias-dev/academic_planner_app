import 'package:academic_planner/src/features/disciplines/presentation/screens/disciplines/widgets/disciplines_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DisciplinesHeaderWidget renders the title and subtitle', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: DisciplinesHeaderWidget(totalDisciplines: 8)),
      ),
    );

    expect(find.text('Disciplinas'), findsOneWidget);
    expect(
      find.text('Análise e Desenvolvimento de Sistemas'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.account_tree_rounded), findsOneWidget);
  });
}
