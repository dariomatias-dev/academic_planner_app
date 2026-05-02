import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';

import 'package:academic_planner/src/features/disciplines/presentation/widgets/disciplines_summary/disciplines_summary_widget.dart';

import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/features/disciplines/presentation/widgets/discipline_card/discipline_card_item_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/periods_tab_bar/periods_tab_bar_widget.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: "Disciplinas",
        actions: <Widget>[
          IconButtonWidget(
            icon: Icons.account_tree_rounded,
            onPressed: () => AppRoutes.goToSchedule(context),
            style: IconButtonStyle.primary,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 20.0),
            decoration: BoxDecoration(color: colorScheme.surface),
            child: Text(
              "Análise e Desenvolvimento de Sistemas",
              style: GoogleFonts.plusJakartaSans(
                color: colorScheme.onSurface.withAlpha(160),
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          PeriodsTabBarWidget(controller: tabController, periods: periods),
          Expanded(
            child: TabBarView(
              controller: tabController,
              physics: const BouncingScrollPhysics(),
              children: periods.builder((period, index) {
                final periodDisciplines = adsDisciplines.filter(
                  (d) => d.period == period,
                );

                final totalWorkload = periodDisciplines.fold(
                  0,
                  (sum, item) => sum + item.workload,
                );

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
                  itemCount: periodDisciplines.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return DisciplinesSummaryWidget(
                        count: periodDisciplines.length,
                        workload: totalWorkload,
                      );
                    }

                    final discipline = periodDisciplines[index - 1];

                    return DisciplineCardItemWidget(
                      index: index,
                      discipline: discipline,
                      initialTabIndex: 2,
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
