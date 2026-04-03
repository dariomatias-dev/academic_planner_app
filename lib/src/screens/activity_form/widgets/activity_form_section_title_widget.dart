import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityFormSectionTitleWidget extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry? padding;

  const ActivityFormSectionTitleWidget({
    super.key,
    required this.title,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: padding ?? const EdgeInsets.only(top: 24.0, bottom: 16.0),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.plusJakartaSans(
          color: colorScheme.primary,
          fontSize: 11.0,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
