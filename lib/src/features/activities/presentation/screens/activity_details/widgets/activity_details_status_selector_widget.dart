import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/presentation/extensions/activity_status_extension.dart';
import 'package:academic_planner/src/shared/widgets/selectable_chip_widget.dart';
import 'package:flutter/material.dart';

class ActivityDetailsStatusSelectorWidget extends StatelessWidget {
  const ActivityDetailsStatusSelectorWidget({
    required this.currentStatus,
    required this.onChanged,
    super.key,
  });

  final ActivityStatus? currentStatus;
  final ValueChanged<ActivityStatus> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        spacing: 8.0,
        children: ActivityStatus.values.builder((status, index) {
          return SelectableChipWidget(
            onTap: () => onChanged(status),
            label: status.label,
            isSelected: currentStatus == status,
          );
        }),
      ),
    );
  }
}
