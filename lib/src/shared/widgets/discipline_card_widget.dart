import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';

import 'package:academic_planner/src/shared/models/discipline_model.dart';

class DisciplineCardWidget extends StatelessWidget {
  const DisciplineCardWidget({
    super.key,
    required this.index,
    required this.discipline,
    this.onTap,
    this.trailing,
    this.opacity = 1.0,
  });

  final int index;
  final DisciplineModel discipline;
  final VoidCallback? onTap;
  final Widget? trailing;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: opacity,
        child: Container(
          margin: const EdgeInsets.only(bottom: 20.0),
          height: 110.0,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(28.0),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: AppColors.black.withAlpha(12),
                        blurRadius: 24.0,
                        offset: const Offset(0.0, 8.0),
                      ),
                    ],
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 4.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              discipline.acronym,
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w800,
                                fontSize: 12.0,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              discipline.name,
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textMain,
                                fontWeight: FontWeight.w800,
                                fontSize: 16.0,
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      trailing ??
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: AppColors.textSub.withAlpha(80),
                            size: 16.0,
                          ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 40.0,
                bottom: -10.0,
                child: Text(
                  index.toString().padLeft(2, '0'),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 60.0,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary.withAlpha(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
