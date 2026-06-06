import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivitySectionHeaderWidget extends StatelessWidget {
  final String title;
  final Widget? action;

  const ActivitySectionHeaderWidget({
    super.key,
    required this.title,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 4.0,
          height: 18.0,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(2.0),
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Text(
            title.toUpperCase(),
            style: GoogleFonts.plusJakartaSans(
              color: colorScheme.onSurface,
              fontSize: 13.0,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ),
        ?action,
      ],
    );
  }
}
