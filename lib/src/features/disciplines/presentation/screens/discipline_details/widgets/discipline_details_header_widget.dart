import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DisciplineDetailsHeaderWidget extends StatelessWidget {
  const DisciplineDetailsHeaderWidget({
    required this.acronym,
    required this.name,
    required this.period,
    super.key,
  });

  final String acronym;
  final String name;
  final int period;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 40.0),
      decoration: BoxDecoration(color: colorScheme.surface),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 6.0,
            ),
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              '$periodº PERÍODO',
              style: GoogleFonts.plusJakartaSans(
                color: colorScheme.primary,
                fontSize: 10.0,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            name,
            style: GoogleFonts.plusJakartaSans(
              color: colorScheme.onSurface,
              fontSize: 28.0,
              fontWeight: FontWeight.w900,
              height: 1.1,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            acronym,
            style: GoogleFonts.plusJakartaSans(
              color: colorScheme.onSurface.withAlpha(160),
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
