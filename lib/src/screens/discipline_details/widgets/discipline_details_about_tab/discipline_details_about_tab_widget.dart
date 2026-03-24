import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';

import 'package:academic_planner/src/screens/discipline_details/widgets/discipline_details_about_tab/discipline_details_course_plan_button_widget.dart';
import 'package:academic_planner/src/screens/discipline_details/widgets/discipline_details_about_tab/discipline_details_requirement_expandable_tile_widget.dart';
import 'package:academic_planner/src/screens/discipline_details/widgets/discipline_details_about_tab/discipline_details_section_title_widget.dart';
import 'package:academic_planner/src/screens/discipline_details/widgets/discipline_details_about_tab/discipline_details_stats_grid_widget.dart';

import 'package:academic_planner/src/shared/models/discipline_model.dart';

class DisciplineDetailsAboutTabWidget extends StatelessWidget {
  const DisciplineDetailsAboutTabWidget({
    super.key,
    required this.discipline,
    required this.prerequisites,
    required this.prerequisiteFor,
  });

  final DisciplineModel discipline;
  final List<DisciplineModel> prerequisites;
  final List<DisciplineModel> prerequisiteFor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DisciplineDetailsStatsGridWidget(
              workload: discipline.workload,
              weeklyHours: discipline.weeklyHours,
              professorId: discipline.responsibleProfessorId,
            ),
            const SizedBox(height: 32.0),
            const DisciplineDetailsSectionTitleWidget(
              title: "Sobre a Disciplina",
              icon: Icons.description_outlined,
            ),
            const SizedBox(height: 12.0),
            Text(
              discipline.description,
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
              linkedDisciplines: prerequisites,
              color: AppColors.primary,
            ),
            const SizedBox(height: 12.0),
            DisciplineDetailsRequirementExpandableTileWidget(
              label: "Libera acesso para",
              linkedDisciplines: prerequisiteFor,
              color: AppColors.accent,
            ),
            const SizedBox(height: 32.0),
            const DisciplineDetailsSectionTitleWidget(
              title: "Recursos",
              icon: Icons.attachment_rounded,
            ),
            const SizedBox(height: 16.0),
            DisciplineDetailsCoursePlanButtonWidget(
              url: discipline.coursePlan,
              disciplineName: discipline.name,
            ),
            const SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }
}
