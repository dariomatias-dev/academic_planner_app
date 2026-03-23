import 'package:flutter/material.dart';

import 'package:academic_planner/src/shared/widgets/buttons/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/dialog_widget.dart';

class ConfirmationDialogWidget extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final ButtonStyles confirmStyle;
  final IconData? icon;

  const ConfirmationDialogWidget({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.confirmLabel = "Confirmar",
    this.cancelLabel = "Cancelar",
    this.confirmStyle = ButtonStyles.primary,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      title: title,
      message: message,
      icon: icon,
      iconColor: confirmStyle.backgroundColor,
      actions: Row(
        children: <Widget>[
          Expanded(
            child: ButtonWidget(
              label: cancelLabel,
              style: ButtonStyles.neutral,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: ButtonWidget(
              label: confirmLabel,
              style: confirmStyle,
              onPressed: () {
                Navigator.pop(context);

                onConfirm();
              },
            ),
          ),
        ],
      ),
    );
  }
}
