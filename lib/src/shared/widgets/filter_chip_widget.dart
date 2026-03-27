import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: AppColors.white,
      selectedColor: AppColors.primary,
      checkmarkColor: AppColors.white,
      labelStyle: GoogleFonts.plusJakartaSans(
        color: isSelected ? AppColors.white : AppColors.textSub,
        fontWeight: FontWeight.w700,
        fontSize: 12.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide.none,
      ),
    );
  }
}
