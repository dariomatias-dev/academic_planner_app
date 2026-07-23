import 'package:academic_planner/src/features/course_details/presentation/screens/course_details/widgets/course_details_about_text_widget.dart';
import 'package:academic_planner/src/features/course_details/presentation/screens/course_details/widgets/course_details_action_tiles_widget.dart';
import 'package:academic_planner/src/features/course_details/presentation/screens/course_details/widgets/course_details_coordination_card_widget.dart';
import 'package:academic_planner/src/features/course_details/presentation/screens/course_details/widgets/course_details_footer_widget.dart';
import 'package:academic_planner/src/features/course_details/presentation/screens/course_details/widgets/course_details_hero_widget.dart';
import 'package:academic_planner/src/features/course_details/presentation/screens/course_details/widgets/course_details_legal_sheet_widget.dart';
import 'package:academic_planner/src/features/course_details/presentation/screens/course_details/widgets/course_details_metrics_card_widget.dart';
import 'package:academic_planner/src/features/course_details/presentation/screens/course_details/widgets/course_details_section_header_widget.dart';
import 'package:academic_planner/src/features/course_details/presentation/screens/course_details/widgets/course_details_skill_grid_widget.dart';
import 'package:academic_planner/src/shared/utils/open_url.dart';
import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CourseDetailsScreen extends StatelessWidget {
  const CourseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: 'Detalhes do Curso',
        actions: [
          Consumer(
            builder: (context, ref, child) {
              return IconButtonWidget(
                icon: Icons.launch_rounded,
                onPressed: () async {
                  await openUrl(
                    context,
                    'https://estudante.ifpb.edu.br/cursos/346/',
                  );
                },
                style: IconButtonStyle.primary,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const CourseDetailsHeroWidget(),
            Transform.translate(
              offset: const Offset(0.0, -36.0),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    CourseDetailsMetricsCardWidget(),
                    SizedBox(height: 40.0),
                    _CourseDetailsMainContent(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseDetailsMainContent extends StatelessWidget {
  const _CourseDetailsMainContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CourseDetailsSectionHeaderWidget(title: 'Visão Geral'),
        SizedBox(height: 16.0),
        CourseDetailsAboutTextWidget(),
        SizedBox(height: 40.0),
        CourseDetailsSectionHeaderWidget(title: 'O que você irá aprender'),
        SizedBox(height: 20.0),
        CourseDetailsSkillGridWidget(),
        SizedBox(height: 48.0),
        CourseDetailsSectionHeaderWidget(title: 'Recursos Oficiais'),
        SizedBox(height: 20.0),
        CourseDetailsActionTilesWidget(),
        SizedBox(height: 48.0),
        CourseDetailsSectionHeaderWidget(title: 'Gestão do Curso'),
        SizedBox(height: 20.0),
        CourseDetailsCoordinationCardWidget(),
        SizedBox(height: 48.0),
        CourseDetailsSectionHeaderWidget(title: 'Dados Administrativos'),
        SizedBox(height: 20.0),
        CourseDetailsLegalSheetWidget(),
        SizedBox(height: 64.0),
        CourseDetailsFooterWidget(),
      ],
    );
  }
}
