import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/constants/schedules.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';

import 'package:academic_planner/src/shared/utils/image_export.dart';
import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_buttons.dart';
import 'package:academic_planner/src/shared/widgets/periods_tab_bar/periods_tab_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/schedule_table_view/schedule_table_view_widget.dart';

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
  void initState() {
    super.initState();

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final filteredEntries = schedules.filter((entry) {
      final discipline = adsDisciplines.firstWhere(
        (adsDiscipline) => adsDiscipline.id == entry.disciplineId,
      );

      return discipline.period == _tabController.index + 1;
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        label: "CRONOGRAMA",
        title: "Grade de Aulas",
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
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: theme.dividerTheme.color ?? AppColors.transparent,
                  width: 1.0,
                ),
              ),
            ),
            child: PeriodsTabBarWidget(
              controller: _tabController,
              periods: List<int>.generate(6, (index) => index + 1),
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
    );
  }
}
