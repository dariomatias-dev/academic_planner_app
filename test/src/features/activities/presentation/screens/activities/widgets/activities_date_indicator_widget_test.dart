import 'package:academic_planner/src/features/activities/presentation/screens/activities/widgets/activities_date_indicator_widget.dart';
import 'package:academic_planner/src/shared/utils/date_utils_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
  });

  testWidgets(
    'ActivitiesDateIndicatorWidget renders the formatted current weekday '
    'date',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ActivitiesDateIndicatorWidget()),
        ),
      );

      final expected = DateUtilsHelper.formatWeekdayDate(DateTime.now());

      expect(find.text(expected), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today_rounded), findsOneWidget);
    },
  );
}
