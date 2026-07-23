import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityDetailsRemindersWidget extends StatelessWidget {
  const ActivityDetailsRemindersWidget({required this.reminders, super.key});

  final List<TimeOfDay> reminders;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: reminders.map((time) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Row(
            children: [
              Icon(
                Icons.notifications_active_outlined,
                size: 20.0,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 12.0),
              Text(
                time.format(context),
                style: GoogleFonts.plusJakartaSans(
                  color: colorScheme.onSurface,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
