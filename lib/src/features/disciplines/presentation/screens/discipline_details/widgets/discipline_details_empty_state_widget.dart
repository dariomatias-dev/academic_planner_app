import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DisciplineDetailsEmptyStateWidget extends StatelessWidget {
  const DisciplineDetailsEmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 64.0, color: colorScheme.onSurface.withAlpha(50)),
            const SizedBox(height: 16.0),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18.0,
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14.0,
                color: colorScheme.onSurface.withAlpha(160),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
