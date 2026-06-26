import 'package:academic_planner/src/features/activities/presentation/screens/activity_details/widgets/activity_details_due_date_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
  });

  group('ActivityDetailsDueDateWidget', () {
    testWidgets('no due date → shows the fallback message', (tester) async {
      await tester.pumpWidget(
        _harness(const ActivityDetailsDueDateWidget()),
      );

      expect(find.text('Sem data definida'), findsOneWidget);
      expect(find.text('PRAZO DE ENTREGA'), findsOneWidget);
    });

    testWidgets('due date provided → shows the formatted date', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          ActivityDetailsDueDateWidget(dueDate: DateTime(2025, 3, 10)),
        ),
      );

      expect(find.text('10 de março, 2025'), findsOneWidget);
    });
  });
}
