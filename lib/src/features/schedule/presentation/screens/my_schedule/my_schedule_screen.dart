import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/constants/schedules.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';

import 'package:academic_planner/src/features/disciplines/di/discipline_providers.dart';

import 'package:academic_planner/src/shared/utils/image_export.dart';
import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/schedule_table_view/schedule_table_view_widget.dart';

class MyScheduleScreen extends ConsumerStatefulWidget {
  const MyScheduleScreen({super.key});

  @override
  ConsumerState<MyScheduleScreen> createState() => _MyScheduleScreenState();
}

class _MyScheduleScreenState extends ConsumerState<MyScheduleScreen> {
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

    final userDisciplines = ref.watch(userDisciplinesNotifierProvider);

    final enrolledDisciplines = adsDisciplines.filter(
      (discipline) => userDisciplines.contains(discipline.id),
    );

    final enrolledEntries = schedules.filter(
      (entry) => userDisciplines.contains(entry.disciplineId),
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBarWidget(
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
