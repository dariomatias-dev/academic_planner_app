import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';

class ScheduleTimeCellWidget extends StatelessWidget {
  final String time;
  final bool isBreak;

  const ScheduleTimeCellWidget({
    super.key,
    required this.time,
    this.isBreak = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 26.0),
      color: isBreak ? AppColors.transparent : theme.scaffoldBackgroundColor,
      child: Center(
        child: Text(
          isBreak ? "" : time,
          style: GoogleFonts.plusJakartaSans(
            color: theme.colorScheme.onSurface,
            fontSize: 14.0,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
