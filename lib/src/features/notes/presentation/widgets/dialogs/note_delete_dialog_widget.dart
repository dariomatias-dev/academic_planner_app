import 'package:flutter/material.dart';

import 'package:academic_planner/src/features/notes/domain/entities/note.dart';

import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/dialog_widget.dart';

class NoteDeleteDialogWidget extends StatelessWidget {
  final Note note;
  final Future<void> Function() onDelete;

  const NoteDeleteDialogWidget({
    super.key,
    required this.note,
    required this.onDelete,
  });

  static Future<void> show(
    BuildContext context, {
    required Note note,
    required Future<void> Function() onDelete,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return NoteDeleteDialogWidget(note: note, onDelete: onDelete);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DialogWidget(
      title: "Excluir Anotação",
      message:
          "Tem certeza que deseja excluir '${note.title}'? Esta ação não poderá ser desfeita.",
      icon: Icons.delete_outline_rounded,
      iconColor: colorScheme.error,
      actions: Row(
        children: <Widget>[
          Expanded(
            child: ButtonWidget(
              label: "Cancelar",
              onPressed: () => Navigator.pop(context),
              style: AppButtonStyle.neutral,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: ButtonWidget(
              label: "Excluir",
              onPressed: () async {
                await onDelete();

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              style: AppButtonStyle.destructiveSolid,
            ),
          ),
        ],
      ),
    );
  }
}
