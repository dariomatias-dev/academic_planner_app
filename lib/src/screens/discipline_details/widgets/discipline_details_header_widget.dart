import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';

class DisciplineDetailsHeaderWidget extends StatelessWidget {
  const DisciplineDetailsHeaderWidget({
    super.key,
    required this.acronym,
    required this.name,
    required this.period,
  });

  final String acronym;
  final String name;
  final int period;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 40.0),
      decoration: const BoxDecoration(color: AppColors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.bg,
              fixedSize: const Size(48.0, 48.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            icon: const Icon(
              Icons.chevron_left_rounded,
              color: AppColors.textMain,
              size: 28.0,
            ),
          ),
          const SizedBox(height: 32.0),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 6.0,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              "$periodº PERÍODO",
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.primary,
                fontSize: 10.0,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            name,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textMain,
              fontSize: 28.0,
              fontWeight: FontWeight.w900,
              height: 1.1,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            acronym,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textSub,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
