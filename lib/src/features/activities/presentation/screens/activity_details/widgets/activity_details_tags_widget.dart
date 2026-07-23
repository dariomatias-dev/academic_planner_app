import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityDetailsTagsWidget extends StatelessWidget {
  const ActivityDetailsTagsWidget({required this.tags, super.key});

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: tags.builder((tag, index) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: theme.dividerTheme.color ?? Colors.transparent,
            ),
          ),
          child: Text(
            '#$tag',
            style: GoogleFonts.plusJakartaSans(
              color: colorScheme.onSurface.withAlpha(180),
              fontSize: 13.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      }),
    );
  }
}
