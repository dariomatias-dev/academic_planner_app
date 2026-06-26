import 'package:academic_planner/src/features/activities/presentation/screens/activity_form/widgets/fields/reminders/activity_form_reminder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('ActivityFormReminderWidget', () {
    testWidgets('renders the formatted time', (tester) async {
      await tester.pumpWidget(
        _harness(
          ActivityFormReminderWidget(
            time: const TimeOfDay(hour: 8, minute: 30),
            onRemove: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.access_time_rounded), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('tapping the close icon calls onRemove', (tester) async {
      var removeCalls = 0;

      await tester.pumpWidget(
        _harness(
          ActivityFormReminderWidget(
            time: const TimeOfDay(hour: 8, minute: 30),
            onRemove: () => removeCalls++,
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.close_rounded));

      expect(removeCalls, 1);
    });
  });
}
