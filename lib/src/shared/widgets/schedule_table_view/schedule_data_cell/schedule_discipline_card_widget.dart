import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/constants/teachers.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';

import 'package:academic_planner/src/features/disciplines/data/models/discipline_model.dart';
import 'package:academic_planner/src/features/schedule/data/models/schedule_entry.dart';
import 'package:academic_planner/src/shared/utils/get_teacher_by_id.dart';

class ScheduleDisciplineCardWidget extends StatelessWidget {
  final ScheduleEntry entry;
  final List<DisciplineModel> disciplines;

  const ScheduleDisciplineCardWidget({
    super.key,
    required this.entry,
    required this.disciplines,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dividerColor =
        Theme.of(context).dividerTheme.color ?? AppColors.transparent;

    final discipline = disciplines.firstWhere(
      (discipline) => discipline.id == entry.disciplineId,
    );

    final teacher = getTeacherById(discipline.responsibleProfessorId, teachers);

    return GestureDetector(
      onTap: () {
        AppRoutes.goToDisciplineDetails(
          context,
          disciplineId: discipline.id,
          tab: 2,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: dividerColor, width: 1.0),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: colorScheme.onSurface.withAlpha(15),
              blurRadius: 10.0,
              offset: const Offset(0.0, 4.0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6.0,
                    vertical: 2.0,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Text(
                    discipline.acronym,
                    style: GoogleFonts.plusJakartaSans(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 9.0,
                    ),
                  ),
                ),
                Text(
                  "${discipline.period}º Período",
                  style: GoogleFonts.plusJakartaSans(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 9.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: Text(
                discipline.name,
                style: GoogleFonts.plusJakartaSans(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                  fontSize: 11.0,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4.0),
            Row(
              children: <Widget>[
                Icon(
                  Icons.person_rounded,
                  size: 10.0,
                  color: colorScheme.onSurface.withAlpha(160),
                ),
                const SizedBox(width: 4.0),
                Expanded(
                  child: Text(
                    teacher.name,
                    style: GoogleFonts.plusJakartaSans(
                      color: colorScheme.onSurface.withAlpha(160),
                      fontWeight: FontWeight.w600,
                      fontSize: 9.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
