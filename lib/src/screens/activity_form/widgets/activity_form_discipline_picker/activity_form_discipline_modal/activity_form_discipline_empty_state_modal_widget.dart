import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityFormDisciplineEmptyStateModalWidget extends StatelessWidget {
  const ActivityFormDisciplineEmptyStateModalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(32.0),
            ),
            child: Icon(
              Icons.auto_stories_rounded,
              color: colorScheme.primary,
              size: 48.0,
            ),
          ),
          const SizedBox(height: 28.0),
          Text(
            "Nenhuma disciplina",
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20.0,
              fontWeight: FontWeight.w900,
              color: colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            "Para vincular atividades, você precisa primeiro selecionar as disciplinas que está cursando na tela de minha grade.",
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14.0,
              color: colorScheme.onSurface.withAlpha(160),
              fontWeight: FontWeight.w500,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32.0),
          Container(
            height: 4.0,
            width: 40.0,
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(40),
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
        ],
      ),
    );
  }
}
