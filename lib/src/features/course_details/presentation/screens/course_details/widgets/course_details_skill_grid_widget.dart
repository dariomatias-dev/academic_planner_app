import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CourseDetailsSkillGridWidget extends StatelessWidget {
  const CourseDetailsSkillGridWidget({super.key});

  static const List<(String, IconData)> _skills = [
    ('Software', Icons.code_rounded),
    ('Redes', Icons.lan_rounded),
    ('Dados', Icons.storage_rounded),
    ('Mobile', Icons.smartphone_rounded),
    ('Segurança', Icons.security_rounded),
    ('DevOps', Icons.all_inclusive_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      children: _skills.builder((skill, index) {
        final (label, icon) = skill;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: colorScheme.onSurface.withAlpha(10)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16.0, color: colorScheme.primary),
              const SizedBox(width: 8.0),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
