import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutMissionStatementWidget extends StatelessWidget {
  const AboutMissionStatementWidget({super.key});

  TextStyle _textStyle(
    BuildContext context, {
    double size = 14.0,
    Color? color,
    FontWeight weight = FontWeight.w500,
    double? height,
  }) {
    return GoogleFonts.plusJakartaSans(
      color: color ?? Theme.of(context).colorScheme.onSurface,
      fontSize: size,
      fontWeight: weight,
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Desenvolvido para transformar a rotina estudantil, o Academic Planner '
      'centraliza disciplinas, prazos e metas em uma interface direta. Nosso '
      'objetivo é reduzir a carga cognitiva, permitindo que você mantenha a '
      'atenção onde ela realmente importa.',
      textAlign: TextAlign.center,
      style: _textStyle(
        context,
        color: Theme.of(context).colorScheme.onSurface.withAlpha(160),
        size: 15.0,
        height: 1.8,
      ),
    );
  }
}
