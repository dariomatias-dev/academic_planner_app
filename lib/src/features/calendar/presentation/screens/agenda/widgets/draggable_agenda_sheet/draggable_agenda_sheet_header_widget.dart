import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DraggableAgendaSheetHeaderWidget extends StatelessWidget {
  final DateTime date;
  final String relativeText;
  final int count;

  const DraggableAgendaSheetHeaderWidget({
    super.key,
    required this.date,
    required this.relativeText,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: <Widget>[
        Container(
          width: 48.0,
          height: 5.0,
          margin: const EdgeInsets.only(bottom: 32.0),
          decoration: BoxDecoration(
            color: colorScheme.onSurface.withAlpha(20),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  DateFormat('dd MMMM', 'pt_BR').format(date),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  relativeText,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(14.0),
              decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha(15),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Text(
                count.toString(),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w900,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32.0),
      ],
    );
  }
}
