import 'package:academic_planner/src/features/activities/presentation/screens/activity_form/widgets/fields/reminders/activity_form_reminders_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('ActivityFormRemindersWidget', () {
    testWidgets('no reminders → shows the empty message', (tester) async {
      await tester.pumpWidget(
        _harness(
          ActivityFormRemindersWidget(
            reminders: const [],
            onAdd: () {},
            onRemove: (_) {},
          ),
        ),
      );

      expect(find.text('Nenhum lembrete definido.'), findsOneWidget);
    });

    testWidgets('reminders provided → renders one entry per reminder', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          ActivityFormRemindersWidget(
            reminders: const [
              TimeOfDay(hour: 8, minute: 0),
              TimeOfDay(hour: 14, minute: 30),
            ],
            onAdd: () {},
            onRemove: (_) {},
          ),
        ),
      );

      expect(find.text('Nenhum lembrete definido.'), findsNothing);
      expect(find.byIcon(Icons.access_time_rounded), findsNWidgets(2));
    });

    testWidgets('tapping "+ Novo Horário" calls onAdd', (tester) async {
      var addCalls = 0;

      await tester.pumpWidget(
        _harness(
          ActivityFormRemindersWidget(
            reminders: const [],
            onAdd: () => addCalls++,
            onRemove: (_) {},
          ),
        ),
      );

      await tester.tap(find.text('+ Novo Horário'));

      expect(addCalls, 1);
    });

    testWidgets('removing a reminder calls onRemove with its time', (
      tester,
    ) async {
      const time = TimeOfDay(hour: 8, minute: 0);
      TimeOfDay? removed;

      await tester.pumpWidget(
        _harness(
          ActivityFormRemindersWidget(
            reminders: const [time],
            onAdd: () {},
            onRemove: (value) => removed = value,
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.close_rounded));

      expect(removed, time);
    });
  });
}
