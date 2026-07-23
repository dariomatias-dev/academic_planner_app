import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutBenefitListWidget extends StatelessWidget {
  const AboutBenefitListWidget({super.key});

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
    final colorScheme = Theme.of(context).colorScheme;
    final benefits = <List<Object>>[
      [
        'Acompanhamento de Evolução',
        'Mantenha um registro fiel de notas, faltas e seu desempenho geral.',
        Icons.verified_outlined,
      ],
      [
        'Controle de Cronograma',
        'Visualize seus horários e prazos em um mapa semântico claro.',
        Icons.calendar_today_outlined,
      ],
      [
        'Privacidade Total',
        'Dados armazenados localmente, garantindo sua total segurança.',
        Icons.security_outlined,
      ],
    ];

    return Column(
      children: benefits.builder(
        (benefit, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  benefit[2] as IconData,
                  color: colorScheme.primary,
                  size: 24.0,
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        benefit[0] as String,
                        style: _textStyle(
                          context,
                          weight: FontWeight.w800,
                          size: 15.0,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        benefit[1] as String,
                        style: _textStyle(
                          context,
                          color: colorScheme.onSurface.withAlpha(160),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
