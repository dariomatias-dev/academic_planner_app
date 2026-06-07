import 'dart:async';

import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/features/teacher/data/models/teacher_model.dart';
import 'package:academic_planner/src/features/teacher/data/services/teacher_mock_data.dart';
import 'package:academic_planner/src/features/teacher/presentation/screens/teacher_details/widgets/teacher_details_header_widget.dart';
import 'package:academic_planner/src/features/teacher/presentation/screens/teacher_details/widgets/teacher_details_section_widget.dart';
import 'package:academic_planner/src/features/teacher/presentation/screens/teacher_details/widgets/teacher_details_timeline_item_widget.dart';
import 'package:academic_planner/src/shared/utils/open_url.dart';
import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/empty_state_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/loading_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeacherDetailsScreen extends ConsumerStatefulWidget {
  const TeacherDetailsScreen({required this.teacherId, super.key});

  final int teacherId;

  @override
  ConsumerState<TeacherDetailsScreen> createState() =>
      _TeacherDetailsScreenState();
}

class _TeacherDetailsScreenState extends ConsumerState<TeacherDetailsScreen> {
  TeacherModel? _teacher;
  bool _isLoading = true;

  Future<void> _fetchTeacher() async {
    setState(() => _isLoading = true);

    final result = teachers.where((t) => t.id == widget.teacherId).firstOrNull;

    setState(() {
      _teacher = result;
      _isLoading = false;
    });
  }

  Widget _buildFormationList(List<TeacherFormationModel> formations) {
    return Column(
      children: formations.builder((formation, _) {
        return TeacherDetailsTimelineItemWidget(
          title: formation.degree,
          subtitle: formation.institution,
          period: formation.period,
        );
      }),
    );
  }

  @override
  void initState() {
    super.initState();

    unawaited(_fetchTeacher());
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        appBar: AppBarWidget(title: 'Perfil do Docente'),
        body: LoadingStateWidget(),
      );
    }

    if (_teacher == null) {
      return Scaffold(
        appBar: const AppBarWidget(title: 'Perfil do Docente'),
        body: EmptyStateWidget(
          icon: Icons.person_search_rounded,
          title: 'Docente não encontrado',
          description:
              'Não foi possível localizar os registros deste '
              'professor no sistema acadêmico.',
          actionLabel: 'Voltar',
          onActionPressed: () {
            Navigator.pop(context);
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: 'Perfil do Docente',
        actions: [
          IconButtonWidget(
            icon: Icons.launch_rounded,
            onPressed: () async {
              await openUrl(
                context,
                _teacher!.lattes,
              );
            },
            style: IconButtonStyle.primary,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TeacherDetailsHeaderWidget(teacher: _teacher!),
            const SizedBox(height: 48.0),
            if (_teacher!.academicBackground.isNotEmpty)
              TeacherDetailsSectionWidget(
                title: 'Formação Acadêmica',
                content: _buildFormationList(_teacher!.academicBackground),
              ),
            if (_teacher!.postGraduation.isNotEmpty) ...[
              const SizedBox(height: 40.0),
              TeacherDetailsSectionWidget(
                title: 'Pós-Graduação',
                content: Column(
                  children: _teacher!.postGraduation.builder((
                    specialization,
                    _,
                  ) {
                    return TeacherDetailsTimelineItemWidget(
                      title: specialization.name,
                      subtitle: specialization.institution,
                      period: specialization.period,
                    );
                  }),
                ),
              ),
            ],
            if (_teacher!.postDoctorate.isNotEmpty) ...[
              const SizedBox(height: 40.0),
              TeacherDetailsSectionWidget(
                title: 'Pós-Doutorado',
                content: _buildFormationList(_teacher!.postDoctorate),
              ),
            ],
            if (_teacher!.complementaryEducation.isNotEmpty) ...[
              const SizedBox(height: 40.0),
              TeacherDetailsSectionWidget(
                title: 'Formação Complementar',
                content: Column(
                  children: _teacher!.complementaryEducation.builder((
                    formation,
                    _,
                  ) {
                    return TeacherDetailsTimelineItemWidget(
                      title: formation.name,
                      subtitle: formation.institution,
                      period: '${formation.year} • ${formation.workload}',
                    );
                  }),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
