import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FormSectionTitleWidget extends StatelessWidget {
  const FormSectionTitleWidget({required this.title, super.key, this.padding});

  final String title;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          color: colorScheme.onSurface,
          fontSize: 16.0,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
