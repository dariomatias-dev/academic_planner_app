import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FormFieldLabelWidget extends StatelessWidget {
  const FormFieldLabelWidget({
    required this.label,
    super.key,
    this.isRequired = false,
    this.fontSize = 14.0,
  });

  final String label;
  final bool isRequired;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Text.rich(
      TextSpan(
        text: label,
        style: GoogleFonts.plusJakartaSans(
          color: colorScheme.onSurface,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
        ),
        children: [
          if (isRequired)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w900),
            ),
        ],
      ),
    );
  }
}
