import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/shared/models/discipline_model.dart';

class DisciplineDetailsScreen extends StatelessWidget {
  const DisciplineDetailsScreen({super.key, required this.discipline});

  final DisciplineModel discipline;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DetailHeaderWidget(
              acronym: discipline.acronym,
              name: discipline.name,
              period: discipline.period,
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  QuickStatsGridWidget(
                    workload: discipline.workload,
                    weeklyHours: discipline.weeklyHours,
                    professorId: discipline.responsibleProfessorId,
                  ),
                  const SizedBox(height: 32.0),
                  const SectionTitleWidget(
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
                  const SectionTitleWidget(
                    title: "Requisitos e Dependências",
                    icon: Icons.account_tree_outlined,
                  ),
                  const SizedBox(height: 16.0),
                  RequirementTileWidget(
                    label: "Pré-requisitos",
                    count: discipline.prerequisites.length,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 12.0),
                  RequirementTileWidget(
                    label: "Libera acesso para",
                    count: discipline.prerequisiteFor.length,
                    color: AppColors.accent,
                  ),
                  const SizedBox(height: 32.0),
                  const SectionTitleWidget(
                    title: "Recursos",
                    icon: Icons.attachment_rounded,
                  ),
                  const SizedBox(height: 16.0),
                  CoursePlanButtonWidget(url: discipline.coursePlan),
                  const SizedBox(height: 40.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailHeaderWidget extends StatelessWidget {
  const DetailHeaderWidget({
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
      padding: const EdgeInsets.fromLTRB(24.0, 60.0, 24.0, 40.0),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40.0),
          bottomRight: Radius.circular(40.0),
        ),
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

class QuickStatsGridWidget extends StatelessWidget {
  const QuickStatsGridWidget({
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
          child: StatCardWidget(
            label: "Carga Horária",
            value: "${workload}h",
            icon: Icons.timer_outlined,
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: StatCardWidget(
            label: "Semanais",
            value: "${weeklyHours}h",
            icon: Icons.calendar_view_week_rounded,
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: StatCardWidget(
            label: "Docente",
            value: "Prof. ID $professorId",
            icon: Icons.person_outline_rounded,
          ),
        ),
      ],
    );
  }
}

class StatCardWidget extends StatelessWidget {
  const StatCardWidget({
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
        color: AppColors.white,
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

class SectionTitleWidget extends StatelessWidget {
  const SectionTitleWidget({
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

class RequirementTileWidget extends StatelessWidget {
  const RequirementTileWidget({
    super.key,
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w700,
              fontSize: 14.0,
              color: AppColors.textMain,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 4.0,
            ),
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              "$count Disciplinas",
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800,
                fontSize: 11.0,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CoursePlanButtonWidget extends StatelessWidget {
  const CoursePlanButtonWidget({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 64.0,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[AppColors.primary, AppColors.accent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primary.withAlpha(60),
            blurRadius: 16.0,
            offset: const Offset(0.0, 8.0),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: AppColors.white.withAlpha(45),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.picture_as_pdf_rounded,
                  color: AppColors.white,
                  size: 20.0,
                ),
              ),
              const SizedBox(width: 16.0),
              Text(
                "Visualizar Plano de Ensino",
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 15.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
