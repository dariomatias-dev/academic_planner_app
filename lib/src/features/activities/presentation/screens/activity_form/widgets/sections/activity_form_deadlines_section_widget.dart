import 'package:academic_planner/src/features/activities/presentation/screens/activity_form/widgets/fields/activity_form_date_picker_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activity_form/widgets/fields/reminders/activity_form_reminders_widget.dart';
import 'package:academic_planner/src/shared/widgets/forms/forms.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ActivityFormDeadlinesSectionWidget extends StatelessWidget {
  const ActivityFormDeadlinesSectionWidget({
    required this.dueDate,
    required this.onSelectDate,
    required this.onClearDate,
    required this.reminders,
    required this.onAddReminder,
    required this.onRemoveReminder,
    super.key,
  });

  final ValueListenable<DateTime?> dueDate;
  final VoidCallback onSelectDate;
  final VoidCallback onClearDate;
  final ValueListenable<List<TimeOfDay>> reminders;
  final VoidCallback onAddReminder;
  final void Function(TimeOfDay value) onRemoveReminder;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FormSectionTitleWidget(title: 'Prazos e Lembretes'),
        ValueListenableBuilder<DateTime?>(
          valueListenable: dueDate,
          builder: (context, date, _) {
            return ActivityFormDatePickerWidget(
              dueDate: date,
              onTap: onSelectDate,
              onClear: onClearDate,
            );
          },
        ),
        const SizedBox(height: 16.0),
        ValueListenableBuilder<List<TimeOfDay>>(
          valueListenable: reminders,
          builder: (context, value, _) {
            return ActivityFormRemindersWidget(
              reminders: value,
              onAdd: onAddReminder,
              onRemove: onRemoveReminder,
            );
          },
        ),
      ],
    );
  }
}
