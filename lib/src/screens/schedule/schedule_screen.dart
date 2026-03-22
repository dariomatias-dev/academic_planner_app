import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/constants/schedules.dart';
import 'package:academic_planner/src/shared/models/schedule_entry.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final _days = <String>[
    "Segunda-feira",
    "Terça-feira",
    "Quarta-feira",
    "Quinta-feira",
    "Sexta-feira",
  ];
  int _selectedPeriod = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(16.0, 60.0, 16.0, 24.0),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border(
                bottom: BorderSide(color: AppColors.borderMedium, width: 1.0),
              ),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.bg,
                        fixedSize: const Size(48.0, 48.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          side: BorderSide(color: AppColors.borderMedium),
                        ),
                      ),
                      icon: const Icon(
                        Icons.chevron_left_rounded,
                        color: AppColors.textMain,
                        size: 28.0,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "CRONOGRAMA",
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.primary,
                              fontSize: 10.0,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Text(
                            "Grade de Aulas",
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.textMain,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
                SizedBox(
                  height: 40.0,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 8.0);
                    },
                    itemBuilder: (context, index) {
                      final period = index + 1;
                      final isSelected = _selectedPeriod == period;

                      return GestureDetector(
                        onTap: () => setState(() => _selectedPeriod = period),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.borderMedium,
                              width: 1.5,
                            ),
                            boxShadow: isSelected
                                ? <BoxShadow>[
                                    BoxShadow(
                                      color: AppColors.primary.withAlpha(40),
                                      blurRadius: 8.0,
                                      offset: const Offset(0.0, 4.0),
                                    ),
                                  ]
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "$periodº Período",
                            style: GoogleFonts.plusJakartaSans(
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.textSub,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: AppColors.borderMedium,
                      width: 1.5,
                    ),
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
                          ..._days.map((day) => _buildHeaderCell(day)),
                        ],
                      ),
                      ...timeSlots.map((slot) {
                        if (slot.type != SlotType.classTime) {
                          return TableRow(
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(10),
                              border: Border(
                                bottom: BorderSide(
                                  color: AppColors.borderMedium,
                                ),
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
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: AppColors.borderLight),
                            ),
                          ),
                          children: <Widget>[
                            _buildTimeCell(slot.label),
                            ...List<Widget>.generate(5, (index) {
                              final dayId = index + 1;
                              return _buildDataCell(slot, dayId);
                            }),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: AppColors.borderMedium),
          left: BorderSide(color: AppColors.borderMedium),
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

  Widget _buildDataCell(TimeSlot slot, int dayId) {
    final entries = schedules.where((e) {
      final discipline = adsDisciplines.firstWhere(
        (d) => d.id == e.disciplineId,
      );
      return e.day == dayId &&
          e.time == slot.label &&
          discipline.period == _selectedPeriod;
    }).toList();

    return Container(
      height: 120.0,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: AppColors.borderLight)),
      ),
      child: entries.isEmpty
          ? _buildEmptyStatus()
          : _buildDisciplineCard(entries.first),
    );
  }

  Widget _buildDisciplineCard(ScheduleEntry entry) {
    final discipline = adsDisciplines.firstWhere(
      (d) => d.id == entry.disciplineId,
    );
    return Container(
      padding: const EdgeInsets.all(12.0),
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
          Text(
            discipline.name,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textMain,
              fontWeight: FontWeight.w800,
              fontSize: 12.0,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            children: <Widget>[
              Container(
                width: 20.0,
                height: 20.0,
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 12.0,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  "John Doe",
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textSub,
                    fontWeight: FontWeight.w700,
                    fontSize: 10.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
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
