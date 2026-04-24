import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/core/result/failure.dart';

import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';

import 'package:academic_planner/src/features/activities/presentation/widgets/activity_dialogs/activity_delete_dialog_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/activity_dialogs/activity_removal_failure_dialog_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/activity_dialogs/activity_removal_success_dialog_widget.dart';

Future<bool> deleteActivityFlow({
  required BuildContext context,
  required WidgetRef ref,
  required Activity activity,
}) async {
  bool success = false;

  Future<void> delete() async {
    final activityNotifier = ref.read(activityNotifierProvider.notifier);

    final result = await activityNotifier.delete(activity.id);

    await result.fold(
      onSuccess: (_) async {
        success = true;

        if (!context.mounted) return;

        await ActivityRemovalSuccessDialogWidget.show(context);

        if (!context.mounted) return;

        ref.invalidate(activityNotifierProvider);
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
    activity: activity,
    onDelete: delete,
  );

  return success;
}
