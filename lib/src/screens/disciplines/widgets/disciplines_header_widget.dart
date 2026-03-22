import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';

class DisciplinesHeaderWidget extends StatelessWidget {
  const DisciplinesHeaderWidget({super.key, required this.totalDisciplines});

  final int totalDisciplines;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24.0, 60.0, 24.0, 20.0),
      decoration: const BoxDecoration(color: AppColors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                onPressed: () => Navigator.pop(context),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.bg,
                  fixedSize: const Size(44.0, 44.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                ),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.textMain,
                  size: 20.0,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  "$totalDisciplines DISCIPLINAS",
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 10.0,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          Text(
            "Disciplinas",
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textMain,
              fontSize: 28.0,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            "Análise e Desenvolvimento de Sistemas",
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textSub,
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
