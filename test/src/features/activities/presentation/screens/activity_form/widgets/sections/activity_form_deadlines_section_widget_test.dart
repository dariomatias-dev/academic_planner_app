import 'package:academic_planner/src/features/activities/presentation/screens/activity_form/widgets/sections/activity_form_deadlines_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('ActivityFormDeadlinesSectionWidget', () {
    testWidgets('renders the date picker and the reminders list', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          ActivityFormDeadlinesSectionWidget(
            dueDate: ValueNotifier<DateTime?>(null),
            onSelectDate: () {},
            onClearDate: () {},
            reminders: ValueNotifier<List<TimeOfDay>>(const []),
            onAddReminder: () {},
            onRemoveReminder: (_) {},
          ),
        ),
      );

      expect(find.text('Prazos e Lembretes'), findsOneWidget);
      expect(find.text('Definir prazo'), findsOneWidget);
      expect(find.text('Nenhum lembrete definido.'), findsOneWidget);
    });

    testWidgets('dueDate notifier update reflects in the date picker', (
      tester,
    ) async {
      final dueDate = ValueNotifier<DateTime?>(null);
      addTearDown(dueDate.dispose);

      await tester.pumpWidget(
        _harness(
          ActivityFormDeadlinesSectionWidget(
            dueDate: dueDate,
            onSelectDate: () {},
            onClearDate: () {},
            reminders: ValueNotifier<List<TimeOfDay>>(const []),
            onAddReminder: () {},
            onRemoveReminder: (_) {},
          ),
        ),
      );

      dueDate.value = DateTime(2025, 3, 10);
      await tester.pump();

      expect(find.text('10 / 03 / 2025'), findsOneWidget);
    });

    testWidgets('tapping the date picker calls onSelectDate', (tester) async {
      var tapCalls = 0;

      await tester.pumpWidget(
        _harness(
          ActivityFormDeadlinesSectionWidget(
            dueDate: ValueNotifier<DateTime?>(null),
            onSelectDate: () => tapCalls++,
            onClearDate: () {},
            reminders: ValueNotifier<List<TimeOfDay>>(const []),
            onAddReminder: () {},
            onRemoveReminder: (_) {},
          ),
        ),
      );

      await tester.tap(find.text('Definir prazo'));

      expect(tapCalls, 1);
    });

    testWidgets('reminders notifier update reflects in the reminders list', (
      tester,
    ) async {
      final reminders = ValueNotifier<List<TimeOfDay>>(const []);
      addTearDown(reminders.dispose);

      await tester.pumpWidget(
        _harness(
          ActivityFormDeadlinesSectionWidget(
            dueDate: ValueNotifier<DateTime?>(null),
            onSelectDate: () {},
            onClearDate: () {},
            reminders: reminders,
            onAddReminder: () {},
            onRemoveReminder: (_) {},
          ),
        ),
      );

      reminders.value = const [TimeOfDay(hour: 8, minute: 0)];
      await tester.pump();

      expect(find.text('Nenhum lembrete definido.'), findsNothing);
      expect(find.byIcon(Icons.access_time_rounded), findsOneWidget);
    });
  });
}
