import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';

class CreateTaskCategorySelectorItemWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final bool isSelected;

  const CreateTaskCategorySelectorItemWidget({
    super.key,
    required this.onTap,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(14.0),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: isSelected ? AppColors.white : AppColors.textSub,
            fontWeight: FontWeight.w700,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }
}
