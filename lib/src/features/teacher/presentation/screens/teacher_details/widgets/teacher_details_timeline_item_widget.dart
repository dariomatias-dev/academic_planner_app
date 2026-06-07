import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TeacherDetailsTimelineItemWidget extends StatelessWidget {
  const TeacherDetailsTimelineItemWidget({
    required this.title,
    required this.subtitle,
    required this.period,
    super.key,
  });

  final String title;
  final String subtitle;
  final String period;

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

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12.0,
                height: 12.0,
                margin: const EdgeInsets.only(top: 4.0),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.primary.withAlpha(60),
                    width: 4.0,
                  ),
                ),
              ),
              Container(
                width: 2.0,
                height: 60.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colorScheme.primary.withAlpha(60),
                      colorScheme.primary.withAlpha(0),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: _textStyle(
                    context,
                    weight: FontWeight.w800,
                    size: 15.0,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  subtitle,
                  style: _textStyle(
                    context,
                    color: colorScheme.onSurface.withAlpha(160),
                    weight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6.0),
                Text(
                  period,
                  style: _textStyle(
                    context,
                    color: colorScheme.primary,
                    size: 12.0,
                    weight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
