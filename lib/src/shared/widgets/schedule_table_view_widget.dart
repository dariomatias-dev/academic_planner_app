import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/constants/schedules.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';

import 'package:academic_planner/src/shared/models/discipline_model.dart';
import 'package:academic_planner/src/shared/models/schedule_entry.dart';

final _days = <String>[
  "Segunda-feira",
  "Terça-feira",
  "Quarta-feira",
  "Quinta-feira",
  "Sexta-feira",
];

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
              children: <TableRow>[
                TableRow(
                  decoration: BoxDecoration(color: colorScheme.surface),
                  children: <Widget>[
                    _buildHeaderCell(context, "HORA"),
                    ..._days.map((day) => _buildHeaderCell(context, day)),
                  ],
                ),
                ...timeSlots.map((slot) {
                  if (slot.type != SlotType.classTime) {
                    return TableRow(
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withAlpha(20),
                        border: Border(bottom: BorderSide(color: dividerColor)),
                      ),
                      children: <Widget>[
                        _buildTimeCell(context, slot.label, isBreak: true),
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
                    children: <Widget>[
                      _buildTimeCell(context, slot.label),
                      ...List<Widget>.generate(5, (index) {
                        return _buildDataCell(context, slot, index + 1);
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

  Widget _buildHeaderCell(BuildContext context, String text) {
    final theme = Theme.of(context);
    final dividerColor = theme.dividerTheme.color ?? AppColors.transparent;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: dividerColor),
          bottom: BorderSide(color: dividerColor),
        ),
      ),
      child: Center(
        child: Text(
          text.toUpperCase(),
          style: GoogleFonts.plusJakartaSans(
            color: theme.colorScheme.onSurface,
            fontSize: 10.0,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeCell(
    BuildContext context,
    String time, {
    bool isBreak = false,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 26.0),
      color: isBreak ? AppColors.transparent : theme.scaffoldBackgroundColor,
      child: Center(
        child: Text(
          isBreak ? "" : time,
          style: GoogleFonts.plusJakartaSans(
            color: theme.colorScheme.onSurface,
            fontSize: 14.0,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _buildDataCell(BuildContext context, TimeSlot slot, int dayId) {
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
          ? _buildEmptyStatus(context)
          : _buildDisciplineCard(context, entry),
    );
  }

  Widget _buildDisciplineCard(BuildContext context, ScheduleEntry entry) {
    final colorScheme = Theme.of(context).colorScheme;
    final dividerColor =
        Theme.of(context).dividerTheme.color ?? AppColors.transparent;

    final discipline = disciplines.firstWhere(
      (discipline) => discipline.id == entry.disciplineId,
    );

    return GestureDetector(
      onTap: () {
        AppRoutes.goToDisciplineDetails(
          context,
          disciplineId: discipline.id,
          tab: 2,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: dividerColor, width: 1.0),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: colorScheme.onSurface.withAlpha(15),
              blurRadius: 10.0,
              offset: const Offset(0.0, 4.0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6.0,
                    vertical: 2.0,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Text(
                    discipline.acronym,
                    style: GoogleFonts.plusJakartaSans(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 9.0,
                    ),
                  ),
                ),
                Text(
                  "${discipline.period}º Período",
                  style: GoogleFonts.plusJakartaSans(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 9.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: Text(
                discipline.name,
                style: GoogleFonts.plusJakartaSans(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                  fontSize: 11.0,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4.0),
            Row(
              children: <Widget>[
                Icon(
                  Icons.person_rounded,
                  size: 10.0,
                  color: colorScheme.onSurface.withAlpha(160),
                ),
                const SizedBox(width: 4.0),
                Expanded(
                  child: Text(
                    "Prof. ID: ${entry.teacherId}",
                    style: GoogleFonts.plusJakartaSans(
                      color: colorScheme.onSurface.withAlpha(160),
                      fontWeight: FontWeight.w600,
                      fontSize: 9.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyStatus(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Center(
        child: Text(
          "LIVRE",
          style: GoogleFonts.plusJakartaSans(
            color: theme.colorScheme.onSurface.withAlpha(80),
            fontSize: 10.0,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
