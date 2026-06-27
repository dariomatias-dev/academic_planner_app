import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/constants/schedules.dart';
import 'package:academic_planner/src/core/domain/entities/discipline.dart';
import 'package:academic_planner/src/core/domain/entities/schedule_entry.dart';
import 'package:academic_planner/src/shared/widgets/schedule_table_view/schedule_data_cell/schedule_discipline_card_widget.dart';
import 'package:academic_planner/src/shared/widgets/schedule_table_view/schedule_data_cell/schedule_empty_status_widget.dart';
import 'package:flutter/material.dart';

class ScheduleDataCellWidget extends StatelessWidget {
  const ScheduleDataCellWidget({
    required this.slot,
    required this.dayId,
    required this.entries,
    required this.disciplines,
    super.key,
  });

  final TimeSlot slot;
  final int dayId;
  final List<ScheduleEntry> entries;
  final List<Discipline> disciplines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dividerColor = theme.dividerTheme.color ?? AppColors.transparent;

    final entry = entries.cast<ScheduleEntry?>().firstWhere(
      (e) => e?.day == dayId && e?.time == slot.label,
      orElse: () => null,
    );

    return Container(
      height: 120.0,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: dividerColor.withAlpha(100))),
      ),
      child: entry == null
          ? const ScheduleEmptyStatusWidget()
          : ScheduleDisciplineCardWidget(
              entry: entry,
              disciplines: disciplines,
            ),
    );
  }
}
