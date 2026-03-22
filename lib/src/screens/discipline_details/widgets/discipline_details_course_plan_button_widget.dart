import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';

import 'package:academic_planner/src/screens/pdf_viewer/pdf_viewer_screen.dart';

class DisciplineDetailsCoursePlanButtonWidget extends StatelessWidget {
  const DisciplineDetailsCoursePlanButtonWidget({
    super.key,
    required this.url,
    required this.disciplineName,
  });

  final String url;
  final String disciplineName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 64.0,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[AppColors.primary, AppColors.accent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primary.withAlpha(60),
            blurRadius: 16.0,
            offset: const Offset(0.0, 8.0),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return PdfViewerScreen(
                    url: url,
                    title: disciplineName,
                    subtitle: "Plano de Ensino",
                  );
                },
              ),
            );
          },
          borderRadius: BorderRadius.circular(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
                "Visualizar Plano de Ensino",
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 15.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
