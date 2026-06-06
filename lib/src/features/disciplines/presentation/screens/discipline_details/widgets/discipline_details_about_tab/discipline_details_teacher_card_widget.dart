import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DisciplineDetailsTeacherCardWidget extends StatelessWidget {
  final String teacherName;
  final VoidCallback onTap;

  const DisciplineDetailsTeacherCardWidget({
    super.key,
    required this.teacherName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.onSurface.withAlpha(20)),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24.0,
              backgroundColor: colorScheme.primary.withAlpha(30),
              child: Icon(Icons.person_rounded, color: colorScheme.primary),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teacherName,
                    style: GoogleFonts.plusJakartaSans(
                      color: colorScheme.onSurface,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "Ver perfil do professor",
                    style: GoogleFonts.plusJakartaSans(
                      color: colorScheme.onSurface.withAlpha(120),
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: colorScheme.onSurface.withAlpha(60),
            ),
          ],
        ),
      ),
    );
  }
}
