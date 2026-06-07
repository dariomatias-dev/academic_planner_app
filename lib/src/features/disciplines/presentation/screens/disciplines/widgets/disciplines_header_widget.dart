import 'package:academic_planner/src/core/routes/app_routes.dart';
import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DisciplinesHeaderWidget extends StatelessWidget {
  const DisciplinesHeaderWidget({required this.totalDisciplines, super.key});

  final int totalDisciplines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        AppBarWidget(
          title: '',
          actions: [
            IconButtonWidget(
              icon: Icons.account_tree_rounded,
              onPressed: () => AppRoutes.goToSchedule(context),
              style: IconButtonStyle.primary,
            ),
          ],
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 20.0),
          decoration: BoxDecoration(color: colorScheme.surface),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Disciplinas',
                style: GoogleFonts.plusJakartaSans(
                  color: colorScheme.onSurface,
                  fontSize: 28.0,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                'Análise e Desenvolvimento de Sistemas',
                style: GoogleFonts.plusJakartaSans(
                  color: colorScheme.onSurface.withAlpha(160),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
