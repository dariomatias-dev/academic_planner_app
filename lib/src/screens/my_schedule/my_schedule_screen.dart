import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/constants/schedules.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';

import 'package:academic_planner/src/shared/utils/image_export.dart';
import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/schedule_table_view/schedule_table_view_widget.dart';

const Set<int> studentEnrolledIds = <int>{51, 52, 53, 54, 55};

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final enrolledDisciplines = adsDisciplines.filter(
      (discipline) => studentEnrolledIds.contains(discipline.id),
    );

    final enrolledEntries = schedules.filter(
      (entry) => studentEnrolledIds.contains(entry.disciplineId),
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        actions: <Widget>[
          IconButtonWidget(
            icon: Icons.download_rounded,
            onPressed: _exportSchedule,
            style: IconButtonStyle.primary,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 24.0),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: theme.dividerTheme.color ?? AppColors.transparent,
                  width: 1.0,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "ESTUDANTE",
                  style: GoogleFonts.plusJakartaSans(
                    color: colorScheme.primary,
                    fontSize: 10.0,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  "Minha Grade",
                  style: GoogleFonts.plusJakartaSans(
                    color: colorScheme.onSurface,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w800,
                  ),
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
    );
  }
}
