import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/features/notes/di/note_providers.dart';
import 'package:academic_planner/src/features/notes/domain/entities/note.dart';
import 'package:academic_planner/src/features/notes/presentation/widgets/dialogs/note_delete_dialog_widget.dart';
import 'package:academic_planner/src/features/notes/presentation/widgets/dialogs/note_removal_failure_dialog_widget.dart';
import 'package:academic_planner/src/features/notes/presentation/widgets/dialogs/note_removal_success_dialog_widget.dart';

Future<bool> deleteNoteFlow({
  required BuildContext context,
  required WidgetRef ref,
  required Note note,
}) async {
  bool success = false;

  final navigator = Navigator.of(context, rootNavigator: true);
  final overlayContext = navigator.context;

  final noteNotifier = ref.read(noteNotifierProvider.notifier);

  String? errorMessage;

  Future<bool> attemptDelete() async {
    final result = await noteNotifier.delete(note.id);

    result.fold(
      onSuccess: (_) {},
      onFailure: (failure) {
        errorMessage = failure.message;
      },
    );

    return result.isSuccess;
  }

  Future<bool> showRetryDialog() async {
    bool retry = false;

    await NoteRemovalFailureDialogWidget.show(
      overlayContext,
      errorMessage: errorMessage,
      onRetry: () async {
        retry = true;
      },
    );

    return retry;
  }

  Future<void> onDelete() async {
    var shouldRetry = true;

    while (shouldRetry) {
      final ok = await attemptDelete();

      if (ok) {
        success = true;

        if (!overlayContext.mounted) return;

        Navigator.pop(overlayContext);

        await NoteRemovalSuccessDialogWidget.show(overlayContext);

        return;
      }

      if (!overlayContext.mounted) return;

      shouldRetry = await showRetryDialog();
    }
  }

  await NoteDeleteDialogWidget.show(
    overlayContext,
    note: note,
    onDelete: onDelete,
  );

  return success;
}
