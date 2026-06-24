import 'package:academic_planner/src/shared/widgets/schedule_table_view/schedule_data_cell/schedule_empty_status_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScheduleEmptyStatusWidget', () {
    testWidgets('renders the LIVRE label over the scaffold background', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: ScheduleEmptyStatusWidget())),
        ),
      );

      expect(find.text('LIVRE'), findsOneWidget);

      final context = tester.element(find.text('LIVRE'));
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration! as BoxDecoration;

      expect(decoration.color, Theme.of(context).scaffoldBackgroundColor);
    });
  });
}
