import 'package:academic_planner/src/features/teacher/domain/entities/teacher.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TeacherDetailsHeaderWidget extends StatelessWidget {
  const TeacherDetailsHeaderWidget({required this.teacher, super.key});

  final Teacher teacher;

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
      padding: const EdgeInsets.only(top: 32.0),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primary,
                      colorScheme.primaryContainer,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withAlpha(60),
                      blurRadius: 20.0,
                      offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
              ),
              Text(
                teacher.name.substring(0, 1).toUpperCase(),
                style: _textStyle(
                  context,
                  color: colorScheme.onPrimary,
                  size: 40.0,
                  weight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          Text(
            teacher.name,
            textAlign: TextAlign.center,
            style: _textStyle(
              context,
              size: 26.0,
              weight: FontWeight.w900,
              height: 1.2,
              spacing: -0.5,
            ),
          ),
          const SizedBox(height: 12.0),
          if (teacher.academicBackground.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(100.0),
              ),
              child: Text(
                teacher.academicBackground.first.degree,
                style: _textStyle(
                  context,
                  color: colorScheme.primary,
                  weight: FontWeight.w800,
                  size: 12.0,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
