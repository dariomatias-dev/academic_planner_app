import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CourseDetailsFooterWidget extends StatelessWidget {
  const CourseDetailsFooterWidget({super.key});

  static const _ifpbLogo =
      'https://cdn.brandfetch.io/id27nEqSG5/w/300/h/331/theme/dark/logo.png?c=1bxid64Mup7aczewSAYMX&t=1772898954763';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Center(child: Image.network(_ifpbLogo, height: 70.0)),
        const SizedBox(height: 24.0),
        Text(
          'Instituto Federal da Paraíba',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          'CAMPUS ESPERANÇA',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.0,
            color: colorScheme.primary,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 40.0),
      ],
    );
  }
}
