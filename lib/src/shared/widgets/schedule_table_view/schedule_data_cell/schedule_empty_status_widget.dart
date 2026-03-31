import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScheduleEmptyStatusWidget extends StatelessWidget {
  const ScheduleEmptyStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Center(
        child: Text(
          "LIVRE",
          style: GoogleFonts.plusJakartaSans(
            color: theme.colorScheme.onSurface.withAlpha(80),
            fontSize: 10.0,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
