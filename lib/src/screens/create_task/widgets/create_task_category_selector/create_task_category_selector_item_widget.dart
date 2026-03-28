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
      child: Chip(
        label: Text(label),
        backgroundColor: isSelected ? AppColors.primary : AppColors.white,
        padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 10.0),
        labelPadding: const EdgeInsets.symmetric(horizontal: 12.0),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        labelStyle: GoogleFonts.plusJakartaSans(
          color: isSelected ? AppColors.white : AppColors.textSub,
          fontWeight: FontWeight.w700,
          fontSize: 12.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide.none,
        ),
      ),
    );
  }
}
