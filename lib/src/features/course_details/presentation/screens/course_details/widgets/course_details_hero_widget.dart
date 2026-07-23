import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CourseDetailsHeroWidget extends StatelessWidget {
  const CourseDetailsHeroWidget({super.key});

  TextStyle _textStyle(
    BuildContext context, {
    double size = 14.0,
    Color? color,
    FontWeight weight = FontWeight.w500,
    double? spacing,
    double? height,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      color: color ?? Theme.of(context).colorScheme.onSurface,
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primary.withBlue(160),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(48.0),
          bottomRight: Radius.circular(48.0),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            top: -20,
            child: Icon(
              Icons.terminal_rounded,
              size: 240,
              color: colorScheme.onPrimary.withAlpha(15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(28.0, 48.0, 28.0, 96.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 6.0,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimary.withAlpha(35),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    'CURSO SUPERIOR',
                    style: _textStyle(
                      context,
                      size: 10.0,
                      weight: FontWeight.w900,
                      color: colorScheme.onPrimary,
                      spacing: 2.0,
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                Text(
                  'Análise e\nDesenvolvimento\nde Sistemas',
                  style: _textStyle(
                    context,
                    size: 36.0,
                    weight: FontWeight.w900,
                    color: colorScheme.onPrimary,
                    height: 1.1,
                    spacing: -1.0,
                  ),
                ),
                const SizedBox(height: 24.0),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: colorScheme.onPrimary.withAlpha(40),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.school_rounded,
                        color: colorScheme.onPrimary,
                        size: 16.0,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Text(
                      'IFPB Campus Esperança',
                      style: _textStyle(
                        context,
                        size: 16.0,
                        weight: FontWeight.w700,
                        color: colorScheme.onPrimary.withAlpha(210),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
