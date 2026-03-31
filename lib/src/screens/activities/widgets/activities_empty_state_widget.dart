import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivitiesEmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String message;

  const ActivitiesEmptyStateWidget({
    super.key,
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 24.0),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(28.0),
          border: Border.all(
            color: Theme.of(context).dividerTheme.color ?? Colors.transparent,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 44.0, color: colorScheme.primary.withAlpha(80)),
            const SizedBox(height: 16.0),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                color: colorScheme.onSurface.withAlpha(140),
                fontWeight: FontWeight.w600,
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
