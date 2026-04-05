import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/routes/app_routes.dart';

import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';

class MyDisciplinesEmptyState extends StatelessWidget {
  const MyDisciplinesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 120.0,
              height: 120.0,
              decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha(15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.auto_stories_rounded,
                  size: 56.0,
                  color: colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 32.0),
            Text(
              "Sua grade está vazia",
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                color: colorScheme.onSurface,
                fontSize: 24.0,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              "Selecione as disciplinas que você está cursando para montar seu cronograma acadêmico.",
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                color: colorScheme.onSurface.withAlpha(150),
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 40.0),
            ButtonWidget(
              onPressed: () {
                AppRoutes.goToDisciplineSelection(context);
              },
              label: 'Configurar',
              isFullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}
