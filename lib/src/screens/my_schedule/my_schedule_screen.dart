import 'package:flutter/material.dart';

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

    final enrolledDisciplines = adsDisciplines.filter(
      (discipline) => studentEnrolledIds.contains(discipline.id),
    );

    final enrolledEntries = schedules.filter(
      (entry) => studentEnrolledIds.contains(entry.disciplineId),
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        label: "ESTUDANTE",
        title: "Minha Grade",
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
