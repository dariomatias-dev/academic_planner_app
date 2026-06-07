import 'package:academic_planner/src/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScheduleTimeCellWidget extends StatelessWidget {
  const ScheduleTimeCellWidget({
    required this.time,
    super.key,
    this.isBreak = false,
  });

  final String time;
  final bool isBreak;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 26.0),
      color: isBreak ? AppColors.transparent : theme.scaffoldBackgroundColor,
      child: Center(
        child: Text(
          isBreak ? '' : time,
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
