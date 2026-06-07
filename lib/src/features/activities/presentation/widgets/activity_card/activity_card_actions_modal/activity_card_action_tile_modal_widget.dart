import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityCardActionTileModalWidget extends StatelessWidget {
  const ActivityCardActionTileModalWidget({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveColor = color ?? colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: colorScheme.surface.withAlpha(40),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: effectiveColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Icon(icon, color: effectiveColor, size: 22.0),
              ),
              const SizedBox(width: 16.0),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right_rounded,
                size: 20.0,
                color: colorScheme.onSurface.withAlpha(40),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
