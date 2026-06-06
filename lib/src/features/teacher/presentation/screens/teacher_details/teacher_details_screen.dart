import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/features/teacher/data/services/teacher_mock_data.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/features/teacher/data/models/teacher_model.dart';
import 'package:academic_planner/src/shared/utils/open_url.dart';
import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/empty_state_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/loading_state_widget.dart';

class TeacherDetailsScreen extends ConsumerStatefulWidget {
  final int teacherId;

  const TeacherDetailsScreen({super.key, required this.teacherId});

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

  TextStyle _textStyle(
    BuildContext context, {
    double size = 14.0,
    Color? color,
    FontWeight weight = FontWeight.w500,
    double? spacing,
    double? height,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      color: color ?? Theme.of(context).colorScheme.onSurface,
      fontWeight: weight,
      letterSpacing: spacing,
      height: height,
    );
  }

  @override
  void initState() {
    super.initState();

    _fetchTeacher();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        appBar: AppBarWidget(title: "Perfil do Docente"),
        body: LoadingStateWidget(),
      );
    }

    if (_teacher == null) {
      return Scaffold(
        appBar: const AppBarWidget(title: "Perfil do Docente"),
        body: EmptyStateWidget(
          icon: Icons.person_search_rounded,
          title: "Docente não encontrado",
          description:
              "Não foi possível localizar os registros deste professor no sistema acadêmico.",
          actionLabel: "Voltar",
          onActionPressed: () {
            Navigator.pop(context);
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: "Perfil do Docente",
        actions: [
          IconButtonWidget(
            icon: Icons.launch_rounded,
            onPressed: () {
              openUrl(
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
            _buildEnhancedHeader(context, _teacher!),
            const SizedBox(height: 48.0),
            if (_teacher!.academicBackground.isNotEmpty)
              _buildSection(
                context,
                "Formação Acadêmica",
                _buildFormationList(context, _teacher!.academicBackground),
              ),
            if (_teacher!.postGraduation.isNotEmpty) ...[
              const SizedBox(height: 40.0),
              _buildSection(
                context,
                "Pós-Graduação",
                _buildSpecializationList(context, _teacher!.postGraduation),
              ),
            ],
            if (_teacher!.postDoctorate.isNotEmpty) ...[
              const SizedBox(height: 40.0),
              _buildSection(
                context,
                "Pós-Doutorado",
                _buildFormationList(context, _teacher!.postDoctorate),
              ),
            ],
            if (_teacher!.complementaryEducation.isNotEmpty) ...[
              const SizedBox(height: 40.0),
              _buildSection(
                context,
                "Formação Complementar",
                _buildComplementaryList(
                  context,
                  _teacher!.complementaryEducation,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedHeader(BuildContext context, TeacherModel teacher) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 32.0),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primary,
                      colorScheme.primaryContainer,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withAlpha(60),
                      blurRadius: 20.0,
                      offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
              ),
              Text(
                teacher.name.substring(0, 1).toUpperCase(),
                style: _textStyle(
                  context,
                  size: 40.0,
                  color: colorScheme.onPrimary,
                  weight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          Text(
            teacher.name,
            textAlign: TextAlign.center,
            style: _textStyle(
              context,
              size: 26.0,
              weight: FontWeight.w900,
              height: 1.2,
              spacing: -0.5,
            ),
          ),
          const SizedBox(height: 12.0),
          if (teacher.academicBackground.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(100.0),
              ),
              child: Text(
                teacher.academicBackground.first.degree,
                style: _textStyle(
                  context,
                  color: colorScheme.primary,
                  weight: FontWeight.w800,
                  size: 12.0,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: _textStyle(
            context,
            size: 11.0,
            color: Theme.of(context).colorScheme.primary,
            weight: FontWeight.w900,
            spacing: 1.5,
          ),
        ),
        const SizedBox(height: 20.0),
        content,
      ],
    );
  }

  Widget _buildTimelineItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String period,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12.0,
                height: 12.0,
                margin: const EdgeInsets.only(top: 4.0),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.primary.withAlpha(60),
                    width: 4.0,
                  ),
                ),
              ),
              Container(
                width: 2.0,
                height: 60.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colorScheme.primary.withAlpha(60),
                      colorScheme.primary.withAlpha(0),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: _textStyle(
                    context,
                    weight: FontWeight.w800,
                    size: 15.0,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  subtitle,
                  style: _textStyle(
                    context,
                    color: colorScheme.onSurface.withAlpha(160),
                    size: 14.0,
                    weight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6.0),
                Text(
                  period,
                  style: _textStyle(
                    context,
                    color: colorScheme.primary,
                    size: 12.0,
                    weight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormationList(
    BuildContext context,
    List<TeacherFormationModel> teacherFormations,
  ) {
    return Column(
      children: teacherFormations.builder((teacherFormation, index) {
        return _buildTimelineItem(
          context,
          title: teacherFormation.degree,
          subtitle: teacherFormation.institution,
          period: teacherFormation.period,
        );
      }),
    );
  }

  Widget _buildSpecializationList(
    BuildContext context,
    List<TeacherSpecializationModel> teacherSpecializations,
  ) {
    return Column(
      children: teacherSpecializations.builder((teacherSpecialization, index) {
        return _buildTimelineItem(
          context,
          title: teacherSpecialization.name,
          subtitle: teacherSpecialization.institution,
          period: teacherSpecialization.period,
        );
      }),
    );
  }

  Widget _buildComplementaryList(
    BuildContext context,
    List<TeacherComplementaryFormationModel> teacherComplementaryFormations,
  ) {
    return Column(
      children: teacherComplementaryFormations.builder((
        teacherComplementaryFormation,
        index,
      ) {
        return _buildTimelineItem(
          context,
          title: teacherComplementaryFormation.name,
          subtitle: teacherComplementaryFormation.institution,
          period:
              "${teacherComplementaryFormation.year} • ${teacherComplementaryFormation.workload}",
        );
      }),
    );
  }
}
