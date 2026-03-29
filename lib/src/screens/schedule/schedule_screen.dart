import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/constants/schedules.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';

import 'package:academic_planner/src/shared/utils/image_export.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_buttons.dart';
import 'package:academic_planner/src/shared/widgets/periods_tab_bar/periods_tab_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/schedule_table_view_widget.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with SingleTickerProviderStateMixin {
  final _globalKey = GlobalKey();

  late final _tabController = TabController(length: 6, vsync: this);

  Future<void> _exportSchedule() async {
    await ImageExport.captureAndSave(
      context: context,
      containerKey: _globalKey,
      fileName: "schedule_period_${_tabController.index}",
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredEntries = schedules.filter((entry) {
      final discipline = adsDisciplines.firstWhere(
        (d) => d.id == entry.disciplineId,
      );

      return discipline.period == _tabController.index;
    });

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        top: false,
        child: Column(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                border: Border(
                  bottom: BorderSide(color: AppColors.borderMedium, width: 1.0),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 60.0, 16.0, 0.0),
                    child: Row(
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
                  ),
                  const SizedBox(height: 24.0),
                  PeriodsTabBarWidget(
                    controller: _tabController,
                    periods: List.generate(6, (index) => index + 1),
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
