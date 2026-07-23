import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CourseDetailsSectionHeaderWidget extends StatelessWidget {
  const CourseDetailsSectionHeaderWidget({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 4.0,
          height: 16.0,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(2.0),
          ),
        ),
        const SizedBox(width: 12.0),
        Text(
          title.toUpperCase(),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.0,
            fontWeight: FontWeight.w900,
            color: colorScheme.primary,
            letterSpacing: 2.0,
          ),
        ),
      ],
    );
  }
}
