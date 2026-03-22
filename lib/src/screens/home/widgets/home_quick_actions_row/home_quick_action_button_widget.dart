import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';

class HomeQuickActionButtonWidget extends StatelessWidget {
  const HomeQuickActionButtonWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(color: AppColors.borderMedium),
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: color.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20.0),
            ),
            const SizedBox(width: 12.0),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textMain,
                fontWeight: FontWeight.w700,
                fontSize: 13.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
