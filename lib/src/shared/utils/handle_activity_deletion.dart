import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:academic_planner/src/controllers/activity_controller.dart';

import 'package:academic_planner/src/core/result/failure.dart';

import 'package:academic_planner/src/shared/models/activity_model.dart';
import 'package:academic_planner/src/shared/widgets/activity_dialogs/activity_delete_dialog_widget.dart';
import 'package:academic_planner/src/shared/widgets/activity_dialogs/activity_removal_failure_dialog_widget.dart';
import 'package:academic_planner/src/shared/widgets/activity_dialogs/activity_removal_success_dialog_widget.dart';

Future<bool> handleActivityDeletion({
  required BuildContext context,
  required ActivityModel activity,
}) async {
  bool success = false;

  Future<void> delete() async {
    final result = await context.read<ActivityController>().removeActivity(
      activity.id,
    );

    if (!context.mounted) return;

    await result.whenAsync(
      onSuccess: (_) async {
        success = true;

        await ActivityRemovalSuccessDialogWidget.show(context);

        if (!context.mounted) return;

        Navigator.pop(context);
      },
      onFailure: (failure) async {
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
