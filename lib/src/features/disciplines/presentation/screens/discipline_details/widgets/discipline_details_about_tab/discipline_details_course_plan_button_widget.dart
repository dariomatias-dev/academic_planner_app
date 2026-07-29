import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DisciplineDetailsCoursePlanButtonWidget extends StatelessWidget {
  const DisciplineDetailsCoursePlanButtonWidget({
    required this.url,
    required this.disciplineName,
    super.key,
  });

  final String url;
  final String disciplineName;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      height: 64.0,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.emerald700, AppColors.emerald800],
        ),
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withAlpha(60),
            blurRadius: 16.0,
            offset: const Offset(0.0, 8.0),
          ),
        ],
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: () async {
            await AppRoutes.goToPdfViewer(
              context,
              url: url,
              title: disciplineName,
            );
          },
          borderRadius: BorderRadius.circular(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: AppColors.white.withAlpha(45),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.picture_as_pdf_rounded,
                  color: AppColors.white,
                  size: 20.0,
                ),
              ),
              const SizedBox(width: 16.0),
              Text(
                'Visualizar Plano de Ensino',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
