import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityDetailsNotesWidget extends StatelessWidget {
  const ActivityDetailsNotesWidget({required this.notes, super.key});

  final String notes;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.amber.withAlpha(15),
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: Colors.amber.withAlpha(30)),
      ),
      child: Text(
        notes,
        style: GoogleFonts.plusJakartaSans(
          color: colorScheme.onSurface.withAlpha(200),
          fontSize: 15.0,
          height: 1.5,
        ),
      ),
    );
  }
}
