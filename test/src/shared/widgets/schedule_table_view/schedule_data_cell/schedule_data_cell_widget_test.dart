import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/constants/schedules.dart';
import 'package:academic_planner/src/core/domain/entities/discipline.dart';
import 'package:academic_planner/src/core/domain/entities/schedule_entry.dart';
import 'package:academic_planner/src/shared/widgets/schedule_table_view/schedule_data_cell/schedule_data_cell_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final Discipline _discipline = adsDisciplines.firstWhere((d) => d.id == 15);

void main() {
  Widget harness(Widget child) {
    return MaterialApp(
      home: Scaffold(body: Center(child: child)),
    );
  }

  group('ScheduleDataCellWidget', () {
    testWidgets('no matching entry → shows the empty status', (tester) async {
      await tester.pumpWidget(
        harness(
          const ScheduleDataCellWidget(
            slot: TimeSlot('7:00', SlotType.classTime),
            dayId: 1,
            entries: [],
            disciplines: [],
          ),
        ),
      );

      expect(find.text('LIVRE'), findsOneWidget);
    });

    testWidgets('entry matching day and time → shows the discipline card', (
      tester,
    ) async {
      await tester.pumpWidget(
        harness(
          ScheduleDataCellWidget(
            slot: const TimeSlot('7:00', SlotType.classTime),
            dayId: 2,
            entries: const [
              ScheduleEntry(
                disciplineId: 15,
                day: 2,
                time: '7:00',
                teacherId: 1,
              ),
            ],
            disciplines: [_discipline],
          ),
        ),
      );

      expect(find.text(_discipline.acronym), findsOneWidget);
      expect(find.text('LIVRE'), findsNothing);
    });

    testWidgets('entry on a different day → still shows the empty status', (
      tester,
    ) async {
      await tester.pumpWidget(
        harness(
          ScheduleDataCellWidget(
            slot: const TimeSlot('7:00', SlotType.classTime),
            dayId: 3,
            entries: const [
              ScheduleEntry(
                disciplineId: 15,
                day: 2,
                time: '7:00',
                teacherId: 1,
              ),
            ],
            disciplines: [_discipline],
          ),
        ),
      );

      expect(find.text('LIVRE'), findsOneWidget);
    });
  });
}
