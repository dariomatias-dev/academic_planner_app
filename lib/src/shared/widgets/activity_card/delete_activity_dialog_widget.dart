import 'package:flutter/material.dart';

import 'package:academic_planner/src/shared/models/activity_model.dart';
import 'package:academic_planner/src/shared/widgets/buttons/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/dialog_widget.dart';

class DeleteActivityDialogWidget extends StatelessWidget {
  final ActivityModel task;
  final VoidCallback onDelete;

  const DeleteActivityDialogWidget({
    super.key,
    required this.task,
    required this.onDelete,
  });

  static Future<void> show(
    BuildContext context, {
    required ActivityModel task,
    required VoidCallback onDelete,
  }) async {
    return showDialog(
      context: context, 
      builder: (context) {
        return DeleteActivityDialogWidget(task: task, onDelete: onDelete);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DialogWidget(
      title: "Excluir Atividade",
      message:
          "Tem certeza que deseja excluir '${task.title}'? Esta ação não poderá ser desfeita.",
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
              onPressed: () {
                Navigator.pop(context);

                onDelete();
              },
              style: AppButtonStyle.destructiveSolid,
            ),
          ),
        ],
      ),
    );
  }
}
