import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TeacherDetailsSectionWidget extends StatelessWidget {
  const TeacherDetailsSectionWidget({
    required this.title,
    required this.content,
    super.key,
  });

  final String title;
  final Widget content;

  TextStyle _textStyle(
    BuildContext context, {
    double size = 14.0,
    Color? color,
    FontWeight weight = FontWeight.w500,
    double? spacing,
  }) {
    return GoogleFonts.plusJakartaSans(
      color: color ?? Theme.of(context).colorScheme.onSurface,
      fontSize: size,
      fontWeight: weight,
      letterSpacing: spacing,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: _textStyle(
            context,
            color: Theme.of(context).colorScheme.primary,
            size: 11.0,
            weight: FontWeight.w900,
            spacing: 1.5,
          ),
        ),
        const SizedBox(height: 20.0),
        content,
      ],
    );
  }
}
