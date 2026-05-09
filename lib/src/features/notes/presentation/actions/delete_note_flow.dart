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

  Future<void> delete() async {
    final noteNotifier = ref.read(noteNotifierProvider.notifier);

    final result = await noteNotifier.delete(note.id);

    await result.fold(
      onSuccess: (_) async {
        success = true;

        if (!context.mounted) return;

        await NoteRemovalSuccessDialogWidget.show(context);

        if (!context.mounted) return;

        ref.invalidate(noteNotifierProvider);

        Navigator.pop(context);
      },
      onFailure: (failure) async {
        if (!context.mounted) return;

        await NoteRemovalFailureDialogWidget.show(
          context,
          onRetry: delete,
          errorMessage: failure is DatabaseFailure ? failure.message : null,
        );
      },
    );
  }

  await NoteDeleteDialogWidget.show(context, note: note, onDelete: delete);

  return success;
}
