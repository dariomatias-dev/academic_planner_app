import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';

class ActivityFormReminderWidget extends StatelessWidget {
  final TimeOfDay time;
  final VoidCallback onRemove;

  const ActivityFormReminderWidget({
    super.key,
    required this.time,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
          color: Theme.of(context).dividerTheme.color ?? AppColors.transparent,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time_rounded,
            color: colorScheme.primary,
            size: 16.0,
          ),
          const SizedBox(width: 8.0),
          Text(
            time.format(context),
            style: GoogleFonts.plusJakartaSans(
              color: colorScheme.onSurface,
              fontSize: 13.0,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 8.0),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close_rounded,
              color: colorScheme.onSurface.withAlpha(150),
              size: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
