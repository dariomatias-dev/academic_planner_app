import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/routes/app_routes.dart';

import 'package:academic_planner/src/features/disciplines/data/models/discipline_model.dart';

class ActivityDetailsDisciplineWidget extends StatelessWidget {
  final DisciplineModel discipline;

  const ActivityDetailsDisciplineWidget({super.key, required this.discipline});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        AppRoutes.goToDisciplineDetails(context, disciplineId: discipline.id);
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(
            color: theme.dividerTheme.color ?? Colors.transparent,
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 52.0,
              height: 52.0,
              decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Center(
                child: Text(
                  discipline.acronym,
                  style: GoogleFonts.plusJakartaSans(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    discipline.name,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    "${discipline.period}º Período",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface.withAlpha(140),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: colorScheme.onSurface.withAlpha(80),
            ),
          ],
        ),
      ),
    );
  }
}
