import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';

import 'package:academic_planner/src/screens/disciplines/widgets/disciplines_header_widget.dart';
import 'package:academic_planner/src/screens/disciplines/widgets/disciplines_period_chip_widget.dart';
import 'package:academic_planner/src/screens/disciplines/widgets/disciplines_period_summary/disciplines_period_summary_widget.dart';

import 'package:academic_planner/src/shared/widgets/discipline_card/discipline_card_widget.dart';

class DisciplinesScreen extends StatefulWidget {
  const DisciplinesScreen({super.key});

  @override
  State<DisciplinesScreen> createState() => DisciplinesScreenState();
}

class DisciplinesScreenState extends State<DisciplinesScreen>
    with SingleTickerProviderStateMixin {
  late final tabController = TabController(length: periods.length, vsync: this);

  final periods = adsDisciplines.map((d) => d.period).toSet().toList()..sort();

  @override
  void initState() {
    super.initState();

    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: <Widget>[
          DisciplinesHeaderWidget(totalDisciplines: adsDisciplines.length),
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.only(bottom: 16.0),
            child: TabBar(
              controller: tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              dividerColor: AppColors.transparent,
              indicatorColor: AppColors.transparent,
              overlayColor: WidgetStateProperty.all(AppColors.transparent),
              splashFactory: NoSplash.splashFactory,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              labelPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              tabs: periods.map((period) {
                final isSelected =
                    tabController.index == periods.indexOf(period);

                return Tab(
                  child: DisciplinesPeriodChipWidget(
                    label: "$periodº Período",
                    isSelected: isSelected,
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              physics: const BouncingScrollPhysics(),
              children: periods.map((period) {
                final periodDisciplines = adsDisciplines
                    .where((d) => d.period == period)
                    .toList();

                final totalWorkload = periodDisciplines.fold(
                  0,
                  (sum, item) => sum + item.workload,
                );

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
                  itemCount: periodDisciplines.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return DisciplinesPeriodSummaryWidget(
                        count: periodDisciplines.length,
                        workload: totalWorkload,
                      );
                    }

                    final discipline = periodDisciplines[index - 1];

                    return DisciplineCardWidget(
                      index: index,
                      discipline: discipline,
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
