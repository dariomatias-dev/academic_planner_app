import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/constants/schedules.dart';

import 'package:academic_planner/src/shared/utils/image_export.dart';
import 'package:academic_planner/src/shared/widgets/back_icon_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/schedule_table_view_widget.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final _globalKey = GlobalKey();

  int _selectedPeriod = 1;

  Future<void> _exportSchedule() async {
    await ImageExport.captureAndSave(
      context: context,
      containerKey: _globalKey,
      fileName: "schedule_period_$_selectedPeriod",
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredEntries = schedules.where((entry) {
      final discipline = adsDisciplines.firstWhere(
        (d) => d.id == entry.disciplineId,
      );
      return discipline.period == _selectedPeriod;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        top: false,
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(16.0, 60.0, 16.0, 24.0),
              decoration: const BoxDecoration(
                color: AppColors.white,
                border: Border(
                  bottom: BorderSide(color: AppColors.borderMedium, width: 1.0),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const BackIconButtonWidget(),
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
                      IconButtonWidget(
                        icon: Icons.download_rounded,
                        onPressed: _exportSchedule,
                        style: IconButtonStyles.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  SizedBox(
                    height: 40.0,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 6,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8.0),
                      itemBuilder: (context, index) {
                        final period = index + 1;
                        final isSelected = _selectedPeriod == period;

                        return GestureDetector(
                          onTap: () => setState(() => _selectedPeriod = period),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
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
                                  ? [
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
              child: ScheduleTableViewWidget(
                repaintKey: _globalKey,
                timeSlots: timeSlots,
                entries: filteredEntries,
                disciplines: adsDisciplines,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
