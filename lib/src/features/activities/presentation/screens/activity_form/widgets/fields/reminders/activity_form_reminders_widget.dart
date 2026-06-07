import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activity_form/widgets/fields/reminders/activity_form_reminder_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityFormRemindersWidget extends StatelessWidget {
  const ActivityFormRemindersWidget({
    required this.reminders,
    required this.onAdd,
    required this.onRemove,
    super.key,
  });

  final List<TimeOfDay> reminders;
  final VoidCallback onAdd;
  final void Function(TimeOfDay) onRemove;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Lembretes',
              style: GoogleFonts.plusJakartaSans(
                color: colorScheme.onSurface,
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            GestureDetector(
              onTap: onAdd,
              child: Text(
                '+ Novo Horário',
                style: GoogleFonts.plusJakartaSans(
                  color: colorScheme.primary,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        if (reminders.isEmpty)
          Text(
            'Nenhum lembrete definido.',
            style: GoogleFonts.plusJakartaSans(
              color: colorScheme.onSurface.withAlpha(160),
              fontSize: 12.0,
            ),
          )
        else
          Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            children: reminders.builder((time, index) {
              return ActivityFormReminderWidget(
                time: time,
                onRemove: () => onRemove(time),
              );
            }),
          ),
      ],
    );
  }
}
