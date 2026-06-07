import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutBrandingSectionWidget extends StatelessWidget {
  const AboutBrandingSectionWidget({super.key});

  TextStyle _textStyle(
    BuildContext context, {
    double size = 14.0,
    Color? color,
    FontWeight weight = FontWeight.w500,
    double? spacing,
    double? height,
  }) {
    return GoogleFonts.plusJakartaSans(
      color: color ?? Theme.of(context).colorScheme.onSurface,
      fontSize: size,
      fontWeight: weight,
      letterSpacing: spacing,
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(24.0),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withAlpha(40),
                  blurRadius: 24.0,
                  offset: const Offset(0.0, 8.0),
                ),
              ],
            ),
            child: Icon(
              Icons.auto_stories_rounded,
              color: colorScheme.onPrimary,
              size: 48.0,
            ),
          ),
          const SizedBox(height: 24.0),
          Text(
            'Academic Planner',
            style: _textStyle(
              context,
              size: 28.0,
              weight: FontWeight.w900,
              spacing: -0.5,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            'Gestão Educacional Inteligente',
            style: _textStyle(
              context,
              color: colorScheme.onSurface.withAlpha(160),
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
