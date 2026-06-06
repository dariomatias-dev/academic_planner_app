import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsSectionWidget extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSectionWidget({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      spacing: 16.0,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            title.toUpperCase(),
            style: GoogleFonts.plusJakartaSans(
              color: colorScheme.onSurface.withAlpha(100),
              fontSize: 11.0,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}
