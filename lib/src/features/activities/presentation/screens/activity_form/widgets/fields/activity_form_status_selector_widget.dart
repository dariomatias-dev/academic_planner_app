import 'package:academic_planner/src/core/extensions/activity_status_extension.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/shared/widgets/forms/forms.dart';
import 'package:academic_planner/src/shared/widgets/selectable_chip_widget.dart';
import 'package:flutter/material.dart';

class ActivityFormStatusSelectorWidget extends StatelessWidget {
  const ActivityFormStatusSelectorWidget({
    required this.selectedStatus,
    required this.onSelect,
    super.key,
  });

  final ActivityStatus selectedStatus;
  final void Function(ActivityStatus value) onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FormFieldLabelWidget(label: 'Status', isRequired: true),
        const SizedBox(height: 12.0),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 8.0,
            children: ActivityStatus.values.builder((status, index) {
              final isSelected = selectedStatus == status;

              return SelectableChipWidget(
                onTap: () => onSelect(status),
                label: status.label,
                isSelected: isSelected,
              );
            }),
          ),
        ),
      ],
    );
  }
}
