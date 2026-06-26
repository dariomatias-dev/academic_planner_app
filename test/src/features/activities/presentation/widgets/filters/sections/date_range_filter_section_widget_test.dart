import 'package:academic_planner/src/features/activities/presentation/widgets/filters/sections/date_range_filter_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('DateRangeFilterSectionWidget', () {
    testWidgets('no dates set → shows the placeholders', (tester) async {
      await tester.pumpWidget(
        _harness(
          DateRangeFilterSectionWidget(
            startDate: null,
            endDate: null,
            onStartDateChanged: (_) {},
            onEndDateChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Início'), findsOneWidget);
      expect(find.text('Fim'), findsOneWidget);
      expect(find.text('--/--/--'), findsNWidgets(2));
    });

    testWidgets('dates set → shows them formatted', (tester) async {
      await tester.pumpWidget(
        _harness(
          DateRangeFilterSectionWidget(
            startDate: DateTime(2025, 3),
            endDate: DateTime(2025, 3, 31),
            onStartDateChanged: (_) {},
            onEndDateChanged: (_) {},
          ),
        ),
      );

      expect(find.text('01/03/2025'), findsOneWidget);
      expect(find.text('31/03/2025'), findsOneWidget);
    });

    testWidgets('tapping the start date tile opens a date picker', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          DateRangeFilterSectionWidget(
            startDate: null,
            endDate: null,
            onStartDateChanged: (_) {},
            onEndDateChanged: (_) {},
          ),
        ),
      );

      await tester.tap(find.text('Início'));
      await tester.pumpAndSettle();

      expect(find.byType(DatePickerDialog), findsOneWidget);
    });
  });
}
