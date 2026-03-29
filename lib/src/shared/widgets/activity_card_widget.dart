import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';

import 'package:academic_planner/src/shared/models/activity_model.dart';

class ActivityCardWidget extends StatelessWidget {
  const ActivityCardWidget({super.key, required this.activity});

  final ActivityModel activity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final disciplines = adsDisciplines.firstWhere(
      (disciplines) => disciplines.id == activity.disciplineId,
    );
    final isHighPriority = activity.priority == "Alta";

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: theme.dividerTheme.color ?? AppColors.transparent,
          width: 1.0,
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Center(
              child: Text(
                disciplines.acronym,
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  activity.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 15.0,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  DateFormat('dd MMM').format(activity.deadline),
                  style: TextStyle(
                    color: colorScheme.onSurface.withAlpha(160),
                    fontSize: 13.0,
                  ),
                ),
              ],
            ),
          ),
          if (isHighPriority)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                "URGENTE",
                style: TextStyle(
                  color: colorScheme.error,
                  fontSize: 10.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
