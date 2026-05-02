import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';

import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_details/widgets/discipline_details_about_tab/discipline_details_about_tab_widget.dart';
import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_details/widgets/discipline_details_activities_tab_widget.dart';
import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_details/widgets/discipline_details_empty_state_widget.dart';
import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_details/widgets/discipline_details_header_widget.dart';
import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_details/widgets/discipline_details_tab_bar_delegate.dart';

import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/buttons/floating_action_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/tab_bar_widget.dart';

class DisciplineDetailsScreen extends StatefulWidget {
  final int disciplineId;
  final int? initialTabIndex;

  const DisciplineDetailsScreen({
    super.key,
    required this.disciplineId,
    this.initialTabIndex,
  });

  @override
  State<DisciplineDetailsScreen> createState() =>
      _DisciplineDetailsScreenState();
}

class _DisciplineDetailsScreenState extends State<DisciplineDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(
    length: 3,
    vsync: this,
    initialIndex: widget.initialTabIndex ?? 0,
  );

  bool get _showFab => _tabController.index != 2;

  @override
  void initState() {
    super.initState();

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final discipline = adsDisciplines.firstWhere(
      (discipline) => discipline.id == widget.disciplineId,
    );

    final prerequisites = adsDisciplines.filter(
      (d) => discipline.prerequisites.contains(d.id),
    );

    final prerequisiteFor = adsDisciplines.filter(
      (d) => discipline.prerequisiteFor.contains(d.id),
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const AppBarWidget(),
      floatingActionButton: _showFab
          ? FloatingActionButtonWidget(
              onPressed: () {
                switch (_tabController.index) {
                  case 0:
                    AppRoutes.goToActivityForm(
                      context,
                      disciplineId: discipline.id,
                    );
                    break;
                  case 1:
                    break;
                }
              },
              icon: Icons.add_rounded,
            )
          : null,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: DisciplineDetailsHeaderWidget(
                acronym: discipline.acronym,
                name: discipline.name,
                period: discipline.period,
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: DisciplineDetailsTabBarDelegate(
                TabBarWidget(
                  controller: _tabController,
                  tabs: const <Tab>[
                    Tab(text: "Tarefas"),
                    Tab(text: "Anotações"),
                    Tab(text: "Sobre"),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            DisciplineDetailsActivitiesTabWidget(
              disciplineId: widget.disciplineId,
            ),
            const DisciplineDetailsEmptyStateWidget(
              icon: Icons.edit_note_rounded,
              title: "Sem anotações",
              message: "Você ainda não criou anotações para esta matéria.",
            ),
            DisciplineDetailsAboutTabWidget(
              discipline: discipline,
              prerequisites: prerequisites,
              prerequisiteFor: prerequisiteFor,
            ),
          ],
        ),
      ),
    );
  }
}
