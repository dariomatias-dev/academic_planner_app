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
    final disc = adsDisciplines.firstWhere(
      (d) => d.id == activity.disciplineId,
    );
    final isHighPriority = activity.priority == "Alta";

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Center(
              child: Text(
                disc.acronym,
                style: const TextStyle(
                  color: AppColors.primary,
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
                    color: AppColors.textMain,
                  ),
                ),
                Text(
                  DateFormat('dd MMM').format(activity.deadline),
                  style: const TextStyle(
                    color: AppColors.textSub,
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
                color: AppColors.dangerBg,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Text(
                "URGENTE",
                style: TextStyle(
                  color: AppColors.dangerText,
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
