import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';

class DisciplineDetailsSectionTitleWidget extends StatelessWidget {
  const DisciplineDetailsSectionTitleWidget({
    super.key,
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 20.0, color: AppColors.textMain),
        const SizedBox(width: 10.0),
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.textMain,
            fontWeight: FontWeight.w800,
            fontSize: 18.0,
          ),
        ),
      ],
    );
  }
}
