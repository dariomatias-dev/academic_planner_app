import 'package:academic_planner/src/core/constants/day_names.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/constants/schedules.dart';

import 'package:academic_planner/src/features/disciplines/data/models/discipline_model.dart';
import 'package:academic_planner/src/features/schedule/data/models/schedule_entry.dart';
import 'package:academic_planner/src/shared/widgets/schedule_table_view/schedule_data_cell/schedule_data_cell_widget.dart';
import 'package:academic_planner/src/shared/widgets/schedule_table_view/schedule_header_cell_widget.dart';
import 'package:academic_planner/src/shared/widgets/schedule_table_view/schedule_time_cell_widget.dart';

class ScheduleTableViewWidget extends StatelessWidget {
  final GlobalKey repaintKey;
  final List<TimeSlot> timeSlots;
  final List<ScheduleEntry> entries;
  final List<DisciplineModel> disciplines;

  const ScheduleTableViewWidget({
    super.key,
    required this.repaintKey,
    required this.timeSlots,
    required this.entries,
    required this.disciplines,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dividerColor = theme.dividerTheme.color ?? AppColors.transparent;

    return InteractiveViewer(
      constrained: false,
      minScale: 0.1,
      maxScale: 1.5,
      child: RepaintBoundary(
        key: repaintKey,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: dividerColor, width: 1.5),
            ),
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const <int, TableColumnWidth>{
                0: FixedColumnWidth(80.0),
                1: FixedColumnWidth(210.0),
                2: FixedColumnWidth(210.0),
                3: FixedColumnWidth(210.0),
                4: FixedColumnWidth(210.0),
                5: FixedColumnWidth(210.0),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: colorScheme.surface),
                  children: [
                    ScheduleHeaderCellWidget(text: "HORA"),
                    ...dayNames.builder((dayName, index) {
                      return ScheduleHeaderCellWidget(text: dayName);
                    }),
                  ],
                ),
                ...timeSlots.map((slot) {
                  if (slot.type != SlotType.classTime) {
                    return TableRow(
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withAlpha(20),
                        border: Border(bottom: BorderSide(color: dividerColor)),
                      ),
                      children: [
                        ScheduleTimeCellWidget(time: slot.label, isBreak: true),
                        ...List<Widget>.generate(5, (index) {
                          if (index == 2) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14.0,
                              ),
                              child: Center(
                                child: Text(
                                  slot.label.toUpperCase(),
                                  style: GoogleFonts.plusJakartaSans(
                                    color: colorScheme.primary,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                      ],
                    );
                  }

                  return TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: dividerColor.withAlpha(100)),
                      ),
                    ),
                    children: [
                      ScheduleTimeCellWidget(time: slot.label),
                      ...List<Widget>.generate(5, (index) {
                        return ScheduleDataCellWidget(
                          slot: slot,
                          dayId: index + 1,
                          entries: entries,
                          disciplines: disciplines,
                        );
                      }),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
