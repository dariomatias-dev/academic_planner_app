import 'package:academic_planner/src/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeSelectorModalOptionWidget extends StatelessWidget {
  const ThemeSelectorModalOptionWidget({
    required this.onTap,
    required this.label,
    required this.icon,
    required this.isSelected,
    super.key,
  });

  final VoidCallback onTap;
  final String label;
  final IconData icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary.withAlpha(15)
                : AppColors.transparent,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary.withAlpha(50)
                  : (theme.dividerTheme.color ?? AppColors.transparent),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withAlpha(100),
                size: 22.0,
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    color: colorScheme.onSurface,
                    fontSize: 15.0,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  color: colorScheme.primary,
                  size: 22.0,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
