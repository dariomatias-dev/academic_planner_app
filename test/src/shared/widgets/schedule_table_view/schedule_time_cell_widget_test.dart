import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/shared/widgets/schedule_table_view/schedule_time_cell_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  group('ScheduleTimeCellWidget', () {
    testWidgets('renders the time over the scaffold background by default', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(const ScheduleTimeCellWidget(time: '7:00')),
      );

      expect(find.text('7:00'), findsOneWidget);

      final context = tester.element(find.text('7:00'));
      final container = tester.widget<Container>(find.byType(Container));
      expect(container.color, Theme.of(context).scaffoldBackgroundColor);
    });

    testWidgets('isBreak true → hides the time and uses a transparent bg', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(const ScheduleTimeCellWidget(time: '7:00', isBreak: true)),
      );

      expect(find.text('7:00'), findsNothing);
      expect(find.text(''), findsOneWidget);

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.color, AppColors.transparent);
    });
  });
}
