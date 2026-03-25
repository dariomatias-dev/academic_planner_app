import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';

import 'package:academic_planner/src/screens/create_task/create_task_screen.dart';
import 'package:academic_planner/src/screens/discipline_details/widgets/discipline_details_about_tab/discipline_details_about_tab_widget.dart';
import 'package:academic_planner/src/screens/discipline_details/widgets/discipline_details_empty_state_widget.dart';
import 'package:academic_planner/src/screens/discipline_details/widgets/discipline_details_header_widget.dart';
import 'package:academic_planner/src/screens/discipline_details/widgets/discipline_details_tab_bar_delegate.dart';

import 'package:academic_planner/src/shared/models/discipline_model.dart';

class DisciplineDetailsScreen extends StatefulWidget {
  const DisciplineDetailsScreen({super.key, required this.discipline});

  final DisciplineModel discipline;

  @override
  State<DisciplineDetailsScreen> createState() =>
      _DisciplineDetailsScreenState();
}

class _DisciplineDetailsScreenState extends State<DisciplineDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 3, vsync: this);

  bool _showFab = true;

  @override
  void initState() {
    super.initState();

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _showFab = _tabController.index != 2;
        });
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
    final prerequisitesList = adsDisciplines.filter(
      (d) => widget.discipline.prerequisites.contains(d.id),
    );

    final prerequisiteForList = adsDisciplines.filter(
      (d) => widget.discipline.prerequisiteFor.contains(d.id),
    );

    return Scaffold(
      backgroundColor: AppColors.bg,
      floatingActionButton: _showFab
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CreateTaskScreen();
                    },
                  ),
                );
              },
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: const Icon(
                Icons.add_rounded,
                color: AppColors.white,
                size: 32.0,
              ),
            )
          : null,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                child: DisciplineDetailsHeaderWidget(
                  acronym: widget.discipline.acronym,
                  name: widget.discipline.name,
                  period: widget.discipline.period,
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: DisciplineDetailsTabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSub,
                    indicatorColor: AppColors.primary,
                    indicatorWeight: 3.0,
                    labelStyle: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 14.0,
                    ),
                    unselectedLabelStyle: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                    ),
                    tabs: const <Widget>[
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
              const DisciplineDetailsEmptyStateWidget(
                icon: Icons.assignment_outlined,
                title: "Sem tarefas",
                message: "Nenhuma tarefa pendente para esta disciplina.",
              ),
              const DisciplineDetailsEmptyStateWidget(
                icon: Icons.edit_note_rounded,
                title: "Sem anotações",
                message: "Você ainda não criou anotações para esta matéria.",
              ),
              DisciplineDetailsAboutTabWidget(
                discipline: widget.discipline,
                prerequisites: prerequisitesList,
                prerequisiteFor: prerequisiteForList,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
