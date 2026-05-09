import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PopupMenuActionWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const PopupMenuActionWidget({
    super.key,
    required this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveColor = color ?? colorScheme.onSurface;

    return Row(
      children: <Widget>[
        Icon(icon, size: 20.0, color: effectiveColor),
        const SizedBox(width: 12.0),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: effectiveColor,
            fontSize: 14.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
