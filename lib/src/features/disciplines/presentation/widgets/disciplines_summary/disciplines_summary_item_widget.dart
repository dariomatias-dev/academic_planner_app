import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DisciplinesSummaryItemWidget extends StatelessWidget {
  const DisciplinesSummaryItemWidget({
    required this.icon,
    required this.label,
    required this.value,
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: colorScheme.primary.withAlpha(15),
            borderRadius: BorderRadius.circular(14.0),
          ),
          child: Icon(icon, size: 20.0, color: colorScheme.primary),
        ),
        const SizedBox(width: 14.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                color: colorScheme.onSurface,
                fontSize: 18.0,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: colorScheme.onSurface.withAlpha(120),
                fontSize: 11.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
