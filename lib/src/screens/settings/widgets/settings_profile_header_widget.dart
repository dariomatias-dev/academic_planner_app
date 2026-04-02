import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';

class SettingsProfileHeaderWidget extends StatelessWidget {
  final String name;
  final String email;
  final String course;
  final String campus;

  const SettingsProfileHeaderWidget({
    super.key,
    required this.name,
    required this.email,
    required this.course,
    required this.campus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(32.0),
        border: Border.all(
          color: isDark
              ? theme.dividerTheme.color ?? AppColors.transparent
              : colorScheme.outlineVariant.withAlpha(80),
          width: 1.5,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 50 : 15),
            blurRadius: 40.0,
            offset: const Offset(0.0, 20.0),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: Row(
              children: <Widget>[
                Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    Container(
                      width: 92.0,
                      height: 92.0,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withAlpha(15),
                        borderRadius: BorderRadius.circular(28.0),
                        border: Border.all(
                          color: colorScheme.primary.withAlpha(40),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.person_rounded,
                          color: colorScheme.primary,
                          size: 48.0,
                        ),
                      ),
                    ),
                    Container(
                      height: 30.0,
                      width: 30.0,
                      decoration: BoxDecoration(
                        color: AppColors.emerald500,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.surface,
                          width: 3.5,
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: AppColors.emerald500.withAlpha(60),
                            blurRadius: 10.0,
                            offset: const Offset(0.0, 4.0),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.verified_rounded,
                        size: 14.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.emerald500.withAlpha(15),
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: AppColors.emerald500.withAlpha(30),
                          ),
                        ),
                        child: Text(
                          "CONTA VERIFICADA",
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.emerald500,
                            fontSize: 9.0,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        name,
                        style: GoogleFonts.plusJakartaSans(
                          color: colorScheme.onSurface,
                          fontSize: 26.0,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.0,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        email,
                        style: GoogleFonts.plusJakartaSans(
                          color: colorScheme.onSurface.withAlpha(140),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
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
              children: <Widget>[
                Container(
                  width: 48.0,
                  height: 48.0,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withAlpha(5),
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                  child: Image.network(
                    'https://cdn.brandfetch.io/id27nEqSG5/w/300/h/331/theme/dark/logo.png?c=1bxid64Mup7aczewSAYMX&t=1772898954763',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        course,
                        style: GoogleFonts.plusJakartaSans(
                          color: colorScheme.onSurface,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "IFPB Campus $campus",
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.emerald600,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14.0,
                  color: isDark
                      ? AppColors.emerald500.withAlpha(120)
                      : AppColors.emerald500.withAlpha(100),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
