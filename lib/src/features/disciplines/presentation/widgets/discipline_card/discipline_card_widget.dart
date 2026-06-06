import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/features/teacher/data/services/teacher_mock_data.dart';

import 'package:academic_planner/src/features/disciplines/data/models/discipline_model.dart';
import 'package:academic_planner/src/shared/utils/get_teacher_by_id.dart';

class DisciplineCardWidget extends StatelessWidget {
  final int index;
  final DisciplineModel discipline;
  final VoidCallback? onTap;
  final Widget? trailing;
  final double opacity;

  const DisciplineCardWidget({
    super.key,
    required this.index,
    required this.discipline,
    this.onTap,
    this.trailing,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final teacher = getTeacherById(discipline.responsibleProfessorId, teachers);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: opacity,
        child: Container(
          margin: const EdgeInsets.only(bottom: 20.0),
          height: 130.0,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 20.0,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(28.0),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.onSurface.withAlpha(15),
                        blurRadius: 24.0,
                        offset: const Offset(0.0, 8.0),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 4.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              discipline.acronym,
                              style: GoogleFonts.plusJakartaSans(
                                color: colorScheme.primary,
                                fontSize: 11.0,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 2.0),
                            Text(
                              discipline.name,
                              style: GoogleFonts.plusJakartaSans(
                                color: colorScheme.onSurface,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  size: 14.0,
                                  color: colorScheme.onSurface.withAlpha(120),
                                ),
                                const SizedBox(width: 6.0),
                                Text(
                                  "${discipline.period}º Período",
                                  style: GoogleFonts.plusJakartaSans(
                                    color: colorScheme.onSurface.withAlpha(160),
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                Icon(
                                  Icons.person_outline_rounded,
                                  size: 16.0,
                                  color: colorScheme.onSurface.withAlpha(120),
                                ),
                                const SizedBox(width: 6.0),
                                Expanded(
                                  child: Text(
                                    teacher.name,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: colorScheme.onSurface.withAlpha(
                                        160,
                                      ),
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      trailing ??
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: colorScheme.onSurface.withAlpha(80),
                            size: 16.0,
                          ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 40.0,
                bottom: -10.0,
                child: Text(
                  index.toString().padLeft(2, '0'),
                  style: GoogleFonts.plusJakartaSans(
                    color: colorScheme.primary.withAlpha(18),
                    fontSize: 60.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
