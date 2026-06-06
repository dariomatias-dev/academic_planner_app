import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';

class PeriodTabItemWidget extends StatelessWidget {
  const PeriodTabItemWidget({
    super.key,
    required this.period,
    required this.isSelected,
  });

  final int period;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
              : theme.dividerTheme.color ?? AppColors.transparent,
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
        "$periodº Período",
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
