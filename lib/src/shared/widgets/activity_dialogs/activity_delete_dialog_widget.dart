import 'package:flutter/material.dart';

import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';

import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/dialog_widget.dart';

class ActivityDeleteDialogWidget extends StatelessWidget {
  final Activity activity;
  final Future<void> Function() onDelete;

  const ActivityDeleteDialogWidget({
    super.key,
    required this.activity,
    required this.onDelete,
  });

  static Future<void> show(
    BuildContext context, {
    required Activity activity,
    required Future<void> Function() onDelete,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return ActivityDeleteDialogWidget(activity: activity, onDelete: onDelete);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DialogWidget(
      title: "Excluir Atividade",
      message:
          "Tem certeza que deseja excluir '${activity.title}'? Esta ação não poderá ser desfeita.",
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
