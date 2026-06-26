import 'package:academic_planner/src/features/activities/presentation/screens/activity_form/widgets/fields/activity_form_date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('ActivityFormDatePickerWidget', () {
    testWidgets('no due date → shows the placeholder and hides the clear '
        'button', (tester) async {
      await tester.pumpWidget(
        _harness(
          ActivityFormDatePickerWidget(onTap: () {}, onClear: () {}),
        ),
      );

      expect(find.text('Definir prazo'), findsOneWidget);
      expect(find.byIcon(Icons.close_rounded), findsNothing);
    });

    testWidgets('due date set → shows the formatted date and the clear '
        'button', (tester) async {
      await tester.pumpWidget(
        _harness(
          ActivityFormDatePickerWidget(
            dueDate: DateTime(2025, 3, 10),
            onTap: () {},
            onClear: () {},
          ),
        ),
      );

      expect(find.text('10 / 03 / 2025'), findsOneWidget);
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);
    });

    testWidgets('tapping the field calls onTap', (tester) async {
      var tapCalls = 0;

      await tester.pumpWidget(
        _harness(
          ActivityFormDatePickerWidget(
            onTap: () => tapCalls++,
            onClear: () {},
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector).first);

      expect(tapCalls, 1);
    });

    testWidgets('tapping the clear icon calls onClear', (tester) async {
      var clearCalls = 0;

      await tester.pumpWidget(
        _harness(
          ActivityFormDatePickerWidget(
            dueDate: DateTime(2025, 3, 10),
            onTap: () {},
            onClear: () => clearCalls++,
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.close_rounded));

      expect(clearCalls, 1);
    });
  });
}
