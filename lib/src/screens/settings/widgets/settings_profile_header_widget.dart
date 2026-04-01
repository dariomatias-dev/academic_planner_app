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
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(36.0),
        border: Border.all(
          color: theme.dividerTheme.color ?? AppColors.transparent,
          width: 1.5,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.black.withAlpha(isDark ? 50 : 15),
            blurRadius: 40.0,
            offset: const Offset(0.0, 20.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Positioned(
                top: -30,
                right: -30,
                child: Opacity(
                  opacity: 0.05,
                  child: Image.network(
                    'https://cdn.brandfetch.io/id27nEqSG5/w/300/h/331/theme/dark/logo.png?c=1bxid64Mup7aczewSAYMX&t=1772898954763',
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: Row(
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(
                          width: 104.0,
                          height: 104.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: <Color>[
                                AppColors.emerald500,
                                AppColors.emerald700,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                        Container(
                          width: 96.0,
                          height: 96.0,
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withAlpha(20),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.person_rounded,
                                color: colorScheme.primary,
                                size: 54.0,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: AppColors.emerald500,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colorScheme.surface,
                                width: 3.0,
                              ),
                            ),
                            child: const Icon(
                              Icons.verified_rounded,
                              size: 16.0,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 24.0),
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
                              color: AppColors.emerald500.withAlpha(25),
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: AppColors.emerald500.withAlpha(50),
                              ),
                            ),
                            child: Text(
                              "ESTUDANTE ADS",
                              style: GoogleFonts.plusJakartaSans(
                                color: isDark
                                    ? AppColors.emerald400
                                    : AppColors.emerald700,
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
                              letterSpacing: -1.2,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            email,
                            style: GoogleFonts.plusJakartaSans(
                              color: isDark
                                  ? AppColors.slate400
                                  : AppColors.slate700,
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
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor.withAlpha(150),
              border: Border(
                top: BorderSide(
                  color: theme.dividerTheme.color ?? AppColors.transparent,
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              children: <Widget>[
                Image.network(
                  'https://cdn.brandfetch.io/id27nEqSG5/w/300/h/331/theme/dark/logo.png?c=1bxid64Mup7aczewSAYMX&t=1772898954763',
                  width: 32.0,
                  height: 32.0,
                  fit: BoxFit.contain,
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
                          fontSize: 12.0,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "IFPB Campus $campus",
                        style: GoogleFonts.plusJakartaSans(
                          color: colorScheme.primary,
                          fontSize: 11.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
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
