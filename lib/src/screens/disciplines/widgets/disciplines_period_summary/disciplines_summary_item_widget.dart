import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';

class DisciplinesSummaryItemWidget extends StatelessWidget {
  const DisciplinesSummaryItemWidget({
    super.key,
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 16.0, color: AppColors.primary),
          const SizedBox(width: 8.0),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textMain,
              fontSize: 12.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
