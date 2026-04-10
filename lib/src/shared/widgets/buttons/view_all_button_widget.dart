import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewAllButtonWidget extends StatelessWidget {
  final VoidCallback onTap;

  const ViewAllButtonWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: colorScheme.primary.withAlpha(20),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          "Ver Todas",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.0,
            fontWeight: FontWeight.w800,
            color: colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
