import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DisciplinesSummaryItemWidget extends StatelessWidget {
  final IconData icon;
  final String label;

  const DisciplinesSummaryItemWidget({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
          color:
              theme.dividerTheme.color ?? colorScheme.onSurface.withAlpha(20),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 16.0, color: colorScheme.primary),
          const SizedBox(width: 8.0),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: colorScheme.onSurface,
              fontSize: 12.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
