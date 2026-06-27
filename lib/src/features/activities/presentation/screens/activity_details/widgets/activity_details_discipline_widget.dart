import 'package:academic_planner/src/core/domain/entities/discipline.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityDetailsDisciplineWidget extends StatelessWidget {
  const ActivityDetailsDisciplineWidget({required this.discipline, super.key});

  final Discipline discipline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () async {
        await AppRoutes.goToDisciplineDetails(
          context,
          disciplineId: discipline.id,
        );
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
          children: [
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
                children: [
                  Text(
                    discipline.name,
                    style: GoogleFonts.plusJakartaSans(
                      color: colorScheme.onSurface,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '${discipline.period}º Período',
                    style: GoogleFonts.plusJakartaSans(
                      color: colorScheme.onSurface.withAlpha(140),
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
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
