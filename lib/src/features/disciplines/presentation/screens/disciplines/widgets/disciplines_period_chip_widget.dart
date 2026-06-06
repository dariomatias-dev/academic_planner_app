import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';

class DisciplinesPeriodChipWidget extends StatelessWidget {
  const DisciplinesPeriodChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
  });

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? colorScheme.onSurface : colorScheme.surface,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(
          color: isSelected
              ? colorScheme.onSurface
              : Theme.of(context).dividerTheme.color ?? AppColors.transparent,
          width: 1.2,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: colorScheme.onSurface.withAlpha(30),
                  blurRadius: 15.0,
                  offset: const Offset(0.0, 8.0),
                ),
              ]
            : [],
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          color: isSelected
              ? colorScheme.surface
              : colorScheme.onSurface.withAlpha(160),
          fontSize: 13.0,
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
        ),
      ),
    );
  }
}
