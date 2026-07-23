import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/presentation/extensions/activity_status_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityDetailsHeaderWidget extends StatelessWidget {
  const ActivityDetailsHeaderWidget({
    required this.category,
    required this.status,
    super.key,
  });

  final String? category;
  final ActivityStatus? status;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        if (category != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 6.0,
            ),
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(25),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              category!.toUpperCase(),
              style: GoogleFonts.plusJakartaSans(
                color: colorScheme.primary,
                fontSize: 10.0,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ),
          ),
          const SizedBox(width: 12.0),
        ],
        Container(
          width: 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            color:
                status?.color(colorScheme) ??
                colorScheme.onSurface.withAlpha(80),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8.0),
        Text(
          (status?.label ?? 'Sem Status').toUpperCase(),
          style: GoogleFonts.plusJakartaSans(
            color: colorScheme.onSurface.withAlpha(150),
            fontSize: 11.0,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
