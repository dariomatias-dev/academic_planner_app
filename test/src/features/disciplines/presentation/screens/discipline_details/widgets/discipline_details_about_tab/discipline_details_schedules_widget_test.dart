import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_details/widgets/discipline_details_about_tab/discipline_details_schedules_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('DisciplineDetailsSchedulesWidget', () {
    testWidgets('no schedules for the discipline → shows the empty '
        'message', (tester) async {
      await tester.pumpWidget(
        _harness(
          const DisciplineDetailsSchedulesWidget(
            disciplineId: -1,
            period: 1,
          ),
        ),
      );

      expect(find.text('Nenhum horário definido.'), findsOneWidget);
    });

    testWidgets('discipline with schedules → groups the times by day', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          const DisciplineDetailsSchedulesWidget(
            disciplineId: 14,
            period: 1,
          ),
        ),
      );

      expect(find.text('Quinta'), findsOneWidget);
      expect(find.text('Sexta'), findsOneWidget);
      expect(find.text('8:40'), findsOneWidget);
      expect(find.text('13:20'), findsOneWidget);
      expect(find.text('Nenhum horário definido.'), findsNothing);
    });
  });
}
