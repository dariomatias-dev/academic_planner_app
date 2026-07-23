import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityDetailsSectionTitleWidget extends StatelessWidget {
  const ActivityDetailsSectionTitleWidget({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.plusJakartaSans(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 11.0,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
