import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/calendar/presentation/screens/agenda/widgets/draggable_agenda_sheet/draggable_agenda_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

Activity _activity({
  String id = 'a1',
  String title = 'Prova de Calculo',
  DateTime? dueDate,
}) => Activity(
  id: id,
  title: title,
  description: 'desc',
  disciplineId: 14,
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
  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
  });

  group('DraggableAgendaSheetWidget', () {
    testWidgets('no activities on the selected day → shows the empty '
        'state', (tester) async {
      await tester.pumpWidget(
        _harness(
          DraggableAgendaSheetWidget(
            selectedDate: DateTime(2025, 3, 10),
            activities: [
              _activity(dueDate: DateTime(2025, 3, 11)),
            ],
            scrollController: ScrollController(),
          ),
        ),
      );

      expect(find.text('Tudo limpo por aqui!'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('activities on the selected day → renders one card each '
        'and the count', (tester) async {
      await tester.pumpWidget(
        _harness(
          DraggableAgendaSheetWidget(
            selectedDate: DateTime(2025, 3, 10),
            activities: [
              _activity(dueDate: DateTime(2025, 3, 10, 8)),
              _activity(id: 'a2', dueDate: DateTime(2025, 3, 10, 14)),
              _activity(id: 'a3', dueDate: DateTime(2025, 3, 11)),
            ],
            scrollController: ScrollController(),
          ),
        ),
      );

      expect(find.text('Tudo limpo por aqui!'), findsNothing);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('08:00'), findsOneWidget);
      expect(find.text('14:00'), findsOneWidget);
    });

    testWidgets('selected day is today → header shows "Hoje"', (
      tester,
    ) async {
      final today = DateTime.now();

      await tester.pumpWidget(
        _harness(
          DraggableAgendaSheetWidget(
            selectedDate: today,
            activities: const [],
            scrollController: ScrollController(),
          ),
        ),
      );

      expect(find.text('Hoje'), findsOneWidget);
    });

    testWidgets('selected day is tomorrow → header shows "Amanhã"', (
      tester,
    ) async {
      final tomorrow = DateTime.now().add(const Duration(days: 1));

      await tester.pumpWidget(
        _harness(
          DraggableAgendaSheetWidget(
            selectedDate: tomorrow,
            activities: const [],
            scrollController: ScrollController(),
          ),
        ),
      );

      expect(find.text('Amanhã'), findsOneWidget);
    });
  });
}
