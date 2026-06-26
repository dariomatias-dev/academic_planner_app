import 'package:academic_planner/src/features/calendar/presentation/screens/agenda/widgets/draggable_agenda_sheet/draggable_agenda_sheet_header_widget.dart';
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

  group('DraggableAgendaSheetHeaderWidget', () {
    testWidgets('renders the formatted date, relative text and count', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          DraggableAgendaSheetHeaderWidget(
            date: DateTime(2025, 3, 10),
            relativeText: 'Hoje',
            count: 3,
          ),
        ),
      );

      expect(find.text('10 março'), findsOneWidget);
      expect(find.text('Hoje'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });
  });
}
