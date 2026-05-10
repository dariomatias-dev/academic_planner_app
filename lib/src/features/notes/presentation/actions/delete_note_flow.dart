import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/core/result/failure.dart';

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

  Future<void> delete() async {
    final result = await noteNotifier.delete(note.id);

    await result.fold(
      onSuccess: (_) async {
        success = true;

        if (!overlayContext.mounted) return;

        await NoteRemovalSuccessDialogWidget.show(overlayContext);

        if (!overlayContext.mounted) return;

        ref.invalidate(noteNotifierProvider);

        navigator.pop();
      },
      onFailure: (failure) async {
        if (!overlayContext.mounted) return;

        await NoteRemovalFailureDialogWidget.show(
          overlayContext,
          onRetry: delete,
          errorMessage: failure is DatabaseFailure ? failure.message : null,
        );
      },
    );
  }

  await NoteDeleteDialogWidget.show(
    overlayContext,
    note: note,
    onDelete: delete,
  );

  return success;
}
