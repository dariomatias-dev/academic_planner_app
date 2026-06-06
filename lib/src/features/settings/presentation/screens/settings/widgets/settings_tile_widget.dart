import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';

class SettingsTileWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? color;

  const SettingsTileWidget({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveColor = color ?? colorScheme.onSurface;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: theme.dividerTheme.color ?? AppColors.transparent,
          width: 1.0,
        ),
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 44.0,
                  height: 44.0,
                  decoration: BoxDecoration(
                    color: (color ?? colorScheme.primary).withAlpha(15),
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  child: Icon(
                    icon,
                    color: color ?? colorScheme.primary,
                    size: 20.0,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      color: effectiveColor,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                trailing ??
                    Icon(
                      Icons.chevron_right_rounded,
                      color: colorScheme.onSurface.withAlpha(60),
                      size: 22.0,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
