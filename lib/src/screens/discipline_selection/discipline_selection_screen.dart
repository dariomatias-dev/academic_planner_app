import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';

import 'package:academic_planner/src/screens/discipline_selection/widgets/discipline_selection_add_tab_content/discipline_selection_add_tab_content_widget.dart';
import 'package:academic_planner/src/screens/discipline_selection/widgets/discipline_selection_my_grade_tab_widget.dart';
import 'package:academic_planner/src/screens/discipline_selection/widgets/discipline_selection_period_selector_widget.dart';

import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_buttons.dart';
import 'package:academic_planner/src/shared/widgets/tab_bar_widget.dart';

class DisciplineSelectionScreen extends StatefulWidget {
  const DisciplineSelectionScreen({super.key});

  @override
  State<DisciplineSelectionScreen> createState() =>
      _DisciplineSelectionScreenState();
}

class _DisciplineSelectionScreenState extends State<DisciplineSelectionScreen>
    with TickerProviderStateMixin {
  late final _mainTabController = TabController(length: 2, vsync: this);
  late final _periodTabController = TabController(
    length: _periods.length,
    vsync: this,
  );

  final _periods = adsDisciplines.map((d) => d.period).toSet().toList()..sort();

  @override
  void initState() {
    super.initState();

    _mainTabController.addListener(() => setState(() {}));
    _periodTabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _periodTabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAddTab = _mainTabController.index == 1;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: "Configurar Grade",
        actions: <Widget>[
          IconButtonWidget(
            icon: Icons.account_tree_rounded,
            onPressed: () {
              AppRoutes.goToMySchedule(context);
            },
            style: IconButtonStyle.primary,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          TabBarWidget(
            controller: _mainTabController,
            backgroundColor: Theme.of(context).colorScheme.surface,
            tabs: const <Tab>[
              Tab(text: "Minha Grade"),
              Tab(text: "Adicionar"),
            ],
          ),
          if (isAddTab)
            DisciplineSelectionPeriodSelectorWidget(
              controller: _periodTabController,
              periods: _periods,
            ),
          Expanded(
            child: TabBarView(
              controller: _mainTabController,
              children: <Widget>[
                DisciplineSelectionMyGradeTabWidget(),
                DisciplineSelectionAddTabContentWidget(
                  periods: _periods,
                  periodController: _periodTabController,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
