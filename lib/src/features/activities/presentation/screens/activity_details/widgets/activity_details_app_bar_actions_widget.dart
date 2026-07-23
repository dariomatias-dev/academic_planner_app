import 'package:academic_planner/src/core/routes/app_routes.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/presentation/actions/delete_activity_flow.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/popup_menu/popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActivityDetailsAppBarActionsWidget extends ConsumerWidget {
  const ActivityDetailsAppBarActionsWidget({
    required this.activity,
    required this.hasStatusChanged,
    required this.onSaveStatus,
    required this.onEdited,
    super.key,
  });

  final Activity activity;
  final bool hasStatusChanged;
  final VoidCallback onSaveStatus;
  final Future<void> Function() onEdited;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasStatusChanged) ...[
          IconButtonWidget(
            icon: Icons.check_rounded,
            onPressed: onSaveStatus,
            style: IconButtonStyle.primary,
          ),
          const SizedBox(width: 8.0),
        ],
        PopupMenuWidget(
          items: [
            PopupMenuActions.edit(
              onTap: () async {
                final result = await AppRoutes.goToActivityForm(
                  context,
                  activityId: activity.id,
                );

                if (result ?? false) await onEdited();
              },
            ),
            PopupMenuActions.delete(
              onTap: () async {
                final result = await deleteActivityFlow(
                  context: context,
                  ref: ref,
                  activity: activity,
                );

                if (result && context.mounted) {
                  Navigator.pop(context);
                }
              },
              color: colorScheme.error,
            ),
          ],
        ),
      ],
    );
  }
}
