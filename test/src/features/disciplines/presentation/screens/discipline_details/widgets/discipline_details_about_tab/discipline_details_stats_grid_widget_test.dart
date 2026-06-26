import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_details/widgets/discipline_details_about_tab/discipline_details_stats_grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DisciplineDetailsStatsGridWidget renders both stat cards', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DisciplineDetailsStatsGridWidget(
            workload: 134,
            weeklyHours: 8,
          ),
        ),
      ),
    );

    expect(find.text('134h'), findsOneWidget);
    expect(find.text('Carga Horária'), findsOneWidget);
    expect(find.text('8h'), findsOneWidget);
    expect(find.text('Semanais'), findsOneWidget);
  });
}
