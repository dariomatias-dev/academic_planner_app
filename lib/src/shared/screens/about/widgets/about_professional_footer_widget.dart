import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutProfessionalFooterWidget extends StatelessWidget {
  const AboutProfessionalFooterWidget({super.key});

  TextStyle _textStyle(
    BuildContext context, {
    double size = 14.0,
    Color? color,
    FontWeight weight = FontWeight.w500,
  }) {
    return GoogleFonts.plusJakartaSans(
      color: color ?? Theme.of(context).colorScheme.onSurface,
      fontSize: size,
      fontWeight: weight,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        children: [
          Icon(Icons.verified_rounded, color: colorScheme.primary, size: 24.0),
          const SizedBox(height: 16.0),
          Text(
            'Academic Planner Professional',
            style: _textStyle(context, size: 15.0, weight: FontWeight.w800),
          ),
          const SizedBox(height: 6.0),
          Text(
            '© 2026 Todos os direitos reservados',
            style: _textStyle(
              context,
              color: colorScheme.onSurface.withAlpha(100),
              size: 12.0,
              weight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24.0),
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
