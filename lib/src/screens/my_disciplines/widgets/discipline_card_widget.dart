import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';

import 'package:academic_planner/src/shared/models/discipline_model.dart';

class DisciplineCardWidget extends StatelessWidget {
  const DisciplineCardWidget({super.key, required this.discipline});

  final DisciplineModel discipline;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 54.0,
            height: 54.0,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Center(
              child: Text(
                discipline.acronym,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 10.0,
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
                  discipline.name,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 15.0,
                    color: AppColors.textMain,
                  ),
                ),
                Text(
                  "${discipline.period}º Período",
                  style: const TextStyle(
                    color: AppColors.textSub,
                    fontSize: 13.0,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textSub),
        ],
      ),
    );
  }
}
