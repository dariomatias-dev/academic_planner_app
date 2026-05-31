import 'package:flutter/material.dart';

import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/dialog_widget.dart';

class RemovalConfirmDialogWidget extends StatelessWidget {
  final String title;
  final String message;
  final Future<void> Function() onConfirm;

  const RemovalConfirmDialogWidget({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    required Future<void> Function() onConfirm,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return RemovalConfirmDialogWidget(
          title: title,
          message: message,
          onConfirm: onConfirm,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      title: title,
      message: message,
      icon: Icons.delete_outline_rounded,
      iconColor: Theme.of(context).colorScheme.error,
      actions: Row(
        children: <Widget>[
          Expanded(
            child: ButtonWidget(
              label: 'Cancelar',
              style: AppButtonStyle.neutral,
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: ButtonWidget(
              label: 'Excluir',
              style: AppButtonStyle.destructiveSolid,
              onPressed: () async {
                await onConfirm();
              },
            ),
          ),
        ],
      ),
    );
  }
}
