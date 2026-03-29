import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';

import 'package:academic_planner/src/shared/widgets/buttons/button_widget.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 120.0,
                height: 120.0,
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.explore_off_rounded,
                  size: 60.0,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 32.0),
              Text(
                "Tela não encontrada",
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textMain,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12.0),
              Text(
                "O caminho que você tentou acessar não existe\nou foi movido temporariamente.",
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textSub,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40.0),
              ButtonWidget(
                onPressed: () {
                  AppRoutes.goHome(context);
                },
                isFullWidth: true,
                label: 'Voltar para o Início',
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: context.pop,
                style: TextButton.styleFrom(foregroundColor: AppColors.textSub),
                child: Text(
                  "Voltar",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w700,
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
