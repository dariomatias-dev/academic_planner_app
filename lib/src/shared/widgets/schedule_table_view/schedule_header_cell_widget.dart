import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';

class ScheduleHeaderCellWidget extends StatelessWidget {
  final String text;

  const ScheduleHeaderCellWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dividerColor = theme.dividerTheme.color ?? AppColors.transparent;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: dividerColor),
          bottom: BorderSide(color: dividerColor),
        ),
      ),
      child: Center(
        child: Text(
          text.toUpperCase(),
          style: GoogleFonts.plusJakartaSans(
            color: theme.colorScheme.onSurface,
            fontSize: 10.0,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }
}
