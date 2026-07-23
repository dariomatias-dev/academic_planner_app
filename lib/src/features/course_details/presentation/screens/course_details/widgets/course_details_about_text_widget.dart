import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CourseDetailsAboutTextWidget extends StatelessWidget {
  const CourseDetailsAboutTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'O Tecnólogo em Análise e Desenvolvimento de Sistemas do IFPB Campus '
      'Esperança é capacitado para analisar, projetar, documentar, testar, '
      'implantar e manter sistemas computacionais de informação. Sua atuação '
      'engloba a produção de softwares com qualidade, usabilidade, integridade '
      'e segurança, focando em soluções inovadoras para o mercado global.',
      style: GoogleFonts.plusJakartaSans(
        fontSize: 15.0,
        height: 1.8,
        color: Theme.of(context).colorScheme.onSurface.withAlpha(160),
      ),
    );
  }
}
