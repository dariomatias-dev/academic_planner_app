import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CourseDetailsCoordinationCardWidget extends StatelessWidget {
  const CourseDetailsCoordinationCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(32.0),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withAlpha(30),
            blurRadius: 20.0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30.0,
                backgroundColor: colorScheme.onPrimary.withAlpha(40),
                child: Icon(
                  Icons.person_3_rounded,
                  color: colorScheme.onPrimary,
                  size: 32.0,
                ),
              ),
              const SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Valderi Reis da Silva',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w900,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    Text(
                      'Coordenador de ADS',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onPrimary.withAlpha(180),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 14.0,
            ),
            decoration: BoxDecoration(
              color: colorScheme.onPrimary.withAlpha(30),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.alternate_email_rounded,
                  size: 18.0,
                  color: colorScheme.onPrimary,
                ),
                const SizedBox(width: 12.0),
                Text(
                  'ads.esperanca@ifpb.edu.br',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onPrimary,
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
