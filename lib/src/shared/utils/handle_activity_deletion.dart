import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/core/providers/activity_providers.dart';
import 'package:academic_planner/src/core/result/failure.dart';

import 'package:academic_planner/src/shared/models/activity_model.dart';
import 'package:academic_planner/src/shared/widgets/activity_dialogs/activity_delete_dialog_widget.dart';
import 'package:academic_planner/src/shared/widgets/activity_dialogs/activity_removal_failure_dialog_widget.dart';
import 'package:academic_planner/src/shared/widgets/activity_dialogs/activity_removal_success_dialog_widget.dart';

Future<bool> handleActivityDeletion({
  required BuildContext context,
  required WidgetRef ref,
  required ActivityModel activity,
}) async {
  bool success = false;

  Future<void> delete() async {
    final controller = ref.read(activityControllerProvider);

    final result = await controller.removeActivity(activity.id);

    await result.whenAsync(
      onSuccess: (_) async {
        success = true;

        if (!context.mounted) return;

        await ActivityRemovalSuccessDialogWidget.show(context);

        if (!context.mounted) return;

        Navigator.pop(context);
      },
      onFailure: (failure) async {
        if (!context.mounted) return;

        await ActivityRemovalFailureDialogWidget.show(
          context,
          onRetry: delete,
          errorMessage: failure is DatabaseFailure ? failure.message : null,
        );
      },
    );
  }

  await ActivityDeleteDialogWidget.show(
    context,
    task: activity,
    onDelete: delete,
  );

  return success;
}
