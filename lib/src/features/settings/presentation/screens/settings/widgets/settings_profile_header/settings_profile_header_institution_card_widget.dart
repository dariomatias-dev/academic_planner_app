import 'package:academic_planner/src/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsProfileHeaderInstitutionCardWidget extends StatelessWidget {
  const SettingsProfileHeaderInstitutionCardWidget({super.key});

  static const _staticCourse = 'Análise e Desenvolvimento de Sistemas';
  static const _staticCampus = 'Esperança';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.emerald500.withAlpha(10)
            : AppColors.emerald500.withAlpha(12),
        borderRadius: BorderRadius.circular(28.0),
        border: Border.all(
          color: isDark
              ? AppColors.emerald500.withAlpha(25)
              : AppColors.emerald500.withAlpha(20),
        ),
      ),
      child: Row(
        children: [
          const _InstitutionLogoWidget(),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _staticCourse,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'IFPB Campus $_staticCampus',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.emerald600,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InstitutionLogoWidget extends StatelessWidget {
  const _InstitutionLogoWidget();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 48.0,
      height: 48.0,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10.0),
        ],
      ),
      child: Image.asset(
        'assets/icons/ifpb_icon.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.school_rounded,
            color: AppColors.emerald500,
            size: 24.0,
          );
        },
      ),
    );
  }
}
