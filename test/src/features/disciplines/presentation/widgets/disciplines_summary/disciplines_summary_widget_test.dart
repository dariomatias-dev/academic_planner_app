import 'package:academic_planner/src/features/disciplines/presentation/widgets/disciplines_summary/disciplines_summary_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  testWidgets('DisciplinesSummaryWidget renders the count and the workload '
      'in hours', (tester) async {
    await tester.pumpWidget(
      _harness(const DisciplinesSummaryWidget(count: 8, workload: 480)),
    );

    expect(find.text('8'), findsOneWidget);
    expect(find.text('Disciplinas'), findsOneWidget);
    expect(find.text('480h'), findsOneWidget);
    expect(find.text('Horas Totais'), findsOneWidget);
  });
}
