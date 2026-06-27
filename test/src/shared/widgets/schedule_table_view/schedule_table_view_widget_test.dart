import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/constants/schedules.dart';
import 'package:academic_planner/src/core/domain/entities/discipline.dart';
import 'package:academic_planner/src/core/domain/entities/schedule_entry.dart';
import 'package:academic_planner/src/shared/widgets/schedule_table_view/schedule_table_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final Discipline _discipline = adsDisciplines.firstWhere((d) => d.id == 11);

void main() {
  Widget harness(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  group('ScheduleTableViewWidget', () {
    testWidgets('renders the header row with HORA and the day names', (
      tester,
    ) async {
      await tester.pumpWidget(
        harness(
          ScheduleTableViewWidget(
            repaintKey: GlobalKey(),
            timeSlots: const [TimeSlot('7:00', SlotType.classTime)],
            entries: const [],
            disciplines: adsDisciplines,
          ),
        ),
      );

      expect(find.text('HORA'), findsOneWidget);
      expect(find.text('SEGUNDA-FEIRA'), findsOneWidget);
      expect(find.text('TERÇA-FEIRA'), findsOneWidget);
      expect(find.text('QUARTA-FEIRA'), findsOneWidget);
      expect(find.text('QUINTA-FEIRA'), findsOneWidget);
      expect(find.text('SEXTA-FEIRA'), findsOneWidget);
    });

    testWidgets(
      'class time slot → shows the time and the matching discipline, '
      'leaves the rest as free',
      (tester) async {
        await tester.pumpWidget(
          harness(
            ScheduleTableViewWidget(
              repaintKey: GlobalKey(),
              timeSlots: const [TimeSlot('7:00', SlotType.classTime)],
              entries: const [
                ScheduleEntry(
                  disciplineId: 11,
                  day: 2,
                  time: '7:00',
                  teacherId: 4,
                ),
              ],
              disciplines: [_discipline],
            ),
          ),
        );

        expect(find.text('7:00'), findsOneWidget);
        expect(find.text(_discipline.acronym), findsOneWidget);
        expect(find.text('LIVRE'), findsNWidgets(4));
      },
    );

    testWidgets('break slot → shows the label once, centered, no entries', (
      tester,
    ) async {
      await tester.pumpWidget(
        harness(
          ScheduleTableViewWidget(
            repaintKey: GlobalKey(),
            timeSlots: const [
              TimeSlot('INTERVALO', SlotType.morningBreak),
            ],
            entries: const [],
            disciplines: adsDisciplines,
          ),
        ),
      );

      expect(find.text('INTERVALO'), findsOneWidget);
      expect(find.text('LIVRE'), findsNothing);
    });
  });
}
