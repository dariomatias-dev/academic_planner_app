import 'package:academic_planner/src/screens/discipline_details/widgets/discipline_details_course_plan_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';

import 'package:academic_planner/src/shared/models/discipline_model.dart';
import 'package:academic_planner/src/shared/widgets/discipline_card_widget.dart';

class DisciplineDetailsScreen extends StatefulWidget {
  const DisciplineDetailsScreen({super.key, required this.discipline});

  final DisciplineModel discipline;

  @override
  State<DisciplineDetailsScreen> createState() => _DisciplineDetailsScreenState();
}

class _DisciplineDetailsScreenState extends State<DisciplineDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showFab = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
    final prerequisitesList = adsDisciplines
        .where((d) => widget.discipline.prerequisites.contains(d.id))
        .toList();

    final prerequisiteForList = adsDisciplines
        .where((d) => widget.discipline.prerequisiteFor.contains(d.id))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      floatingActionButton: _showFab
          ? FloatingActionButton(
              onPressed: () {},
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              child: const Icon(Icons.add_rounded, color: AppColors.white, size: 32.0),
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
                delegate: _SliverAppBarDelegate(
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
              _buildEmptyState(
                icon: Icons.assignment_outlined,
                title: "Sem tarefas",
                message: "Nenhuma tarefa pendente para esta disciplina.",
              ),
              _buildEmptyState(
                icon: Icons.edit_note_rounded,
                title: "Sem anotações",
                message: "Você ainda não criou anotações para esta matéria.",
              ),
              _buildAboutTab(prerequisitesList, prerequisiteForList),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 64.0, color: AppColors.textSub.withAlpha(50)),
            const SizedBox(height: 16.0),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18.0,
                fontWeight: FontWeight.w800,
                color: AppColors.textMain,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14.0,
                color: AppColors.textSub,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutTab(List<DisciplineModel> pre, List<DisciplineModel> forList) {
    return Container(
      color: AppColors.white,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DisciplineDetailsStatsGridWidget(
              workload: widget.discipline.workload,
              weeklyHours: widget.discipline.weeklyHours,
              professorId: widget.discipline.responsibleProfessorId,
            ),
            const SizedBox(height: 32.0),
            const DisciplineDetailsSectionTitleWidget(
              title: "Sobre a Disciplina",
              icon: Icons.description_outlined,
            ),
            const SizedBox(height: 12.0),
            Text(
              widget.discipline.description,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15.0,
                color: AppColors.textSub,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32.0),
            const DisciplineDetailsSectionTitleWidget(
              title: "Requisitos e Dependências",
              icon: Icons.account_tree_outlined,
            ),
            const SizedBox(height: 16.0),
            DisciplineDetailsRequirementExpandableTileWidget(
              label: "Pré-requisitos",
              linkedDisciplines: pre,
              color: AppColors.primary,
            ),
            const SizedBox(height: 12.0),
            DisciplineDetailsRequirementExpandableTileWidget(
              label: "Libera acesso para",
              linkedDisciplines: forList,
              color: AppColors.accent,
            ),
            const SizedBox(height: 32.0),
            const DisciplineDetailsSectionTitleWidget(
              title: "Recursos",
              icon: Icons.attachment_rounded,
            ),
            const SizedBox(height: 16.0),
            DisciplineDetailsCoursePlanButtonWidget(
              url: widget.discipline.coursePlan,
              disciplineName: widget.discipline.name,
            ),
            const SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class DisciplineDetailsHeaderWidget extends StatelessWidget {
  const DisciplineDetailsHeaderWidget({
    super.key,
    required this.acronym,
    required this.name,
    required this.period,
  });

  final String acronym;
  final String name;
  final int period;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 40.0),
      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.bg,
              fixedSize: const Size(48.0, 48.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            icon: const Icon(
              Icons.chevron_left_rounded,
              color: AppColors.textMain,
              size: 28.0,
            ),
          ),
          const SizedBox(height: 32.0),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 6.0,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              "$periodº PERÍODO",
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.primary,
                fontSize: 10.0,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            name,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textMain,
              fontSize: 28.0,
              fontWeight: FontWeight.w900,
              height: 1.1,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            acronym,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textSub,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class DisciplineDetailsStatsGridWidget extends StatelessWidget {
  const DisciplineDetailsStatsGridWidget({
    super.key,
    required this.workload,
    required this.weeklyHours,
    required this.professorId,
  });

  final int workload;
  final int weeklyHours;
  final int professorId;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: DisciplineDetailsStatCardWidget(
            label: "Carga Horária",
            value: "${workload}h",
            icon: Icons.timer_outlined,
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: DisciplineDetailsStatCardWidget(
            label: "Semanais",
            value: "${weeklyHours}h",
            icon: Icons.calendar_view_week_rounded,
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: DisciplineDetailsStatCardWidget(
            label: "Docente",
            value: "Prof. ID $professorId",
            icon: Icons.person_outline_rounded,
          ),
        ),
      ],
    );
  }
}

class DisciplineDetailsStatCardWidget extends StatelessWidget {
  const DisciplineDetailsStatCardWidget({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 100.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.bg.withAlpha(150),
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(icon, size: 18.0, color: AppColors.primary),
          const SizedBox(height: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  fontSize: 13.0,
                  color: AppColors.textMain,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w500,
                  fontSize: 9.0,
                  color: AppColors.textSub,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DisciplineDetailsSectionTitleWidget extends StatelessWidget {
  const DisciplineDetailsSectionTitleWidget({
    super.key,
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 20.0, color: AppColors.textMain),
        const SizedBox(width: 10.0),
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            fontSize: 18.0,
            color: AppColors.textMain,
          ),
        ),
      ],
    );
  }
}

class DisciplineDetailsRequirementExpandableTileWidget extends StatefulWidget {
  const DisciplineDetailsRequirementExpandableTileWidget({
    super.key,
    required this.label,
    required this.linkedDisciplines,
    required this.color,
  });

  final String label;
  final List<DisciplineModel> linkedDisciplines;
  final Color color;

  @override
  State<DisciplineDetailsRequirementExpandableTileWidget> createState() =>
      _DisciplineDetailsRequirementExpandableTileWidgetState();
}

class _DisciplineDetailsRequirementExpandableTileWidgetState
    extends State<DisciplineDetailsRequirementExpandableTileWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  void toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        expandController.forward();
      } else {
        expandController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasDisciplines = widget.linkedDisciplines.isNotEmpty;

    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: AppColors.bg.withAlpha(100),
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: hasDisciplines ? toggleExpansion : null,
              borderRadius: BorderRadius.circular(20.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      widget.label,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.0,
                        color: AppColors.textMain,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: widget.color.withAlpha(20),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            "${widget.linkedDisciplines.length} Disciplinas",
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w800,
                              fontSize: 11.0,
                              color: widget.color,
                            ),
                          ),
                        ),
                        if (hasDisciplines) ...<Widget>[
                          const SizedBox(width: 8.0),
                          RotationTransition(
                            turns: Tween<double>(
                              begin: 0.0,
                              end: 0.25,
                            ).animate(animation),
                            child: Icon(
                              Icons.chevron_right_rounded,
                              size: 20.0,
                              color: widget.color,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: animation,
          axisAlignment: 1.0,
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              children: List.generate(
                widget.linkedDisciplines.length,
                (index) => DisciplineCardWidget(
                  discipline: widget.linkedDisciplines[index],
                  index: index + 1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}