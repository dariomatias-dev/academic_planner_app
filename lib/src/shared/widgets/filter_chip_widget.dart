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
    final colorScheme = Theme.of(context).colorScheme;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: colorScheme.surface,
      selectedColor: colorScheme.primary,
      checkmarkColor: colorScheme.onPrimary,
      labelStyle: GoogleFonts.plusJakartaSans(
        color: isSelected
            ? colorScheme.onPrimary
            : colorScheme.onSurface.withAlpha(160),
        fontWeight: FontWeight.w700,
        fontSize: 12.0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      side: BorderSide(
        color: isSelected
            ? colorScheme.primary
            : (Theme.of(context).dividerTheme.color ?? AppColors.transparent),
        width: 1.0,
      ),
    );
  }
}
