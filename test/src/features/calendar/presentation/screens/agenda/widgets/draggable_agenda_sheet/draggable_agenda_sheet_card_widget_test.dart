import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/calendar/presentation/screens/agenda/widgets/draggable_agenda_sheet/draggable_agenda_sheet_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Activity _activity({int disciplineId = 14, DateTime? dueDate}) => Activity(
  id: 'a1',
  title: 'Prova de Calculo',
  description: 'desc',
  disciplineId: disciplineId,
  dueDate: dueDate,
  tags: const [],
  reminders: const [],
  status: ActivityStatus.pending,
  createdAt: DateTime(2025),
  updatedAt: DateTime(2025),
);

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('DraggableAgendaSheetCardWidget', () {
    testWidgets('renders the discipline acronym, title and time', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          DraggableAgendaSheetCardWidget(
            index: 1,
            activity: _activity(dueDate: DateTime(2025, 3, 10, 14, 30)),
          ),
        ),
      );

      expect(find.text('ALGO'), findsOneWidget);
      expect(find.text('Prova de Calculo'), findsOneWidget);
      expect(find.text('14:30'), findsOneWidget);
      expect(find.text('01'), findsOneWidget);
    });

    testWidgets('no due date → shows the time placeholder', (tester) async {
      await tester.pumpWidget(
        _harness(
          DraggableAgendaSheetCardWidget(index: 2, activity: _activity()),
        ),
      );

      expect(find.text('--:--'), findsOneWidget);
      expect(find.text('02'), findsOneWidget);
    });

    testWidgets('unknown discipline → falls back to "GERAL"', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          DraggableAgendaSheetCardWidget(
            index: 1,
            activity: _activity(disciplineId: -1),
          ),
        ),
      );

      expect(find.text('GERAL'), findsOneWidget);
    });
  });
}
