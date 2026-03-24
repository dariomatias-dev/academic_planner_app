import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/constants/schedules.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';

import 'package:academic_planner/src/shared/utils/image_export.dart';
import 'package:academic_planner/src/shared/widgets/back_icon_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/schedule_table_view_widget.dart';

const studentEnrolledIds = {51, 52, 53, 54, 55};

class MyScheduleScreen extends StatefulWidget {
  const MyScheduleScreen({super.key});

  @override
  State<MyScheduleScreen> createState() => _MyScheduleScreenState();
}

class _MyScheduleScreenState extends State<MyScheduleScreen> {
  final _globalKey = GlobalKey();

  Future<void> _exportSchedule() async {
    await ImageExport.captureAndSave(
      context: context,
      containerKey: _globalKey,
      fileName: "my_schedule",
    );
  }

  @override
  Widget build(BuildContext context) {
    final enrolledDisciplines = adsDisciplines.filter(
      (d) => studentEnrolledIds.contains(d.id),
    );

    final enrolledEntries = schedules.filter(
      (entry) => studentEnrolledIds.contains(entry.disciplineId),
    );

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
              child: Row(
                children: <Widget>[
                  const BackIconButtonWidget(),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "ESTUDANTE",
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.primary,
                            fontSize: 10.0,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                        Text(
                          "Minha Grade",
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
            Expanded(
              child: ScheduleTableViewWidget(
                repaintKey: _globalKey,
                timeSlots: timeSlots,
                entries: enrolledEntries,
                disciplines: enrolledDisciplines,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
