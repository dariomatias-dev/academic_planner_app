import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DisciplineDetailsSectionTitleWidget extends StatelessWidget {
  final String title;
  final IconData icon;

  const DisciplineDetailsSectionTitleWidget({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 20.0, color: colorScheme.onSurface),
        const SizedBox(width: 10.0),
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w800,
            fontSize: 18.0,
          ),
        ),
      ],
    );
  }
}
