import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ActivitiesDateIndicatorWidget extends StatelessWidget {
  const ActivitiesDateIndicatorWidget({super.key});

  String _formatDate() {
    final raw = DateFormat(
      "d 'de' MMMM • EEEE",
      'pt_BR',
    ).format(DateTime.now());

    final parts = raw.split('•');

    if (parts.length < 2) return raw;

    final day = parts[1].trim();

    final capitalized = day
        .split('-')
        .map((e) => e.isNotEmpty ? e[0].toUpperCase() + e.substring(1) : e)
        .join('-');

    return "${parts[0]}• $capitalized";
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final formattedDate = _formatDate();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(
              Icons.calendar_today_rounded,
              size: 14.0,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 10.0),
          Text(
            formattedDate,
            style: GoogleFonts.plusJakartaSans(
              color: colorScheme.onSurface.withAlpha(180),
              fontSize: 13.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
