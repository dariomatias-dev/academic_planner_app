import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/constants/schedules.dart';

import 'package:academic_planner/src/screens/discipline_details/discipline_details_screen.dart';

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
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: AppColors.borderMedium, width: 1.5),
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
                  decoration: const BoxDecoration(color: AppColors.white),
                  children: <Widget>[
                    _buildHeaderCell("HORA"),
                    ..._days.map(_buildHeaderCell),
                  ],
                ),
                ...timeSlots.map((slot) {
                  if (slot.type != SlotType.classTime) {
                    return TableRow(
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(10),
                        border: const Border(
                          bottom: BorderSide(color: AppColors.borderMedium),
                        ),
                      ),
                      children: <Widget>[
                        _buildTimeCell(slot.label, isBreak: true),
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
                                    color: AppColors.primary,
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
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.borderLight),
                      ),
                    ),
                    children: <Widget>[
                      _buildTimeCell(slot.label),
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

  Widget _buildHeaderCell(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(color: AppColors.borderMedium),
          bottom: BorderSide(color: AppColors.borderMedium),
        ),
      ),
      child: Center(
        child: Text(
          text.toUpperCase(),
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.black,
            fontSize: 10.0,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeCell(String time, {bool isBreak = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 26.0),
      color: isBreak ? AppColors.transparent : AppColors.bg,
      child: Center(
        child: Text(
          isBreak ? "" : time,
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.textMain,
            fontSize: 14.0,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _buildDataCell(BuildContext context, TimeSlot slot, int dayId) {
    final entry = entries.cast<ScheduleEntry?>().firstWhere(
      (e) => e?.day == dayId && e?.time == slot.label,
      orElse: () => null,
    );

    return Container(
      height: 120.0,
      padding: const EdgeInsets.all(12.0),
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: AppColors.borderLight)),
      ),
      child: entry == null
          ? _buildEmptyStatus()
          : _buildDisciplineCard(context, entry),
    );
  }

  Widget _buildDisciplineCard(BuildContext context, ScheduleEntry entry) {
    final discipline = disciplines.firstWhere(
      (d) => d.id == entry.disciplineId,
    );

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DisciplineDetailsScreen(
                discipline: discipline,
                initialTabIndex: 2,
              );
            },
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: AppColors.borderMedium, width: 1.0),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.textMain.withAlpha(10),
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
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Text(
                    discipline.acronym,
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 9.0,
                    ),
                  ),
                ),
                Text(
                  "${discipline.period}º Período",
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.primary,
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
                  color: AppColors.textMain,
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
                const Icon(
                  Icons.person_rounded,
                  size: 10.0,
                  color: AppColors.textSub,
                ),
                const SizedBox(width: 4.0),
                Expanded(
                  child: Text(
                    "Prof. ID: ${entry.teacherId}",
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textSub,
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

  Widget _buildEmptyStatus() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Center(
        child: Text(
          "LIVRE",
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.textSub.withAlpha(100),
            fontSize: 10.0,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
