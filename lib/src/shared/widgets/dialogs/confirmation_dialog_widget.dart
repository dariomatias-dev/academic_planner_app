import 'package:flutter/material.dart';

import 'package:academic_planner/src/shared/widgets/buttons/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/dialog_widget.dart';

class ConfirmationDialogWidget extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String message;
  final bool vertical;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final ButtonStyles confirmStyle;

  const ConfirmationDialogWidget({
    super.key,
    this.icon,
    required this.title,
    required this.message,
    this.vertical = false,
    required this.onConfirm,
    this.confirmLabel = "Confirmar",
    this.cancelLabel = "Cancelar",
    this.confirmStyle = ButtonStyles.primary,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      Flexible(
        fit: FlexFit.loose,
        child: ButtonWidget(
          onPressed: () => Navigator.pop(context),
          label: cancelLabel,
          style: ButtonStyles.neutral,
          isFullWidth: true,
        ),
      ),
      SizedBox(width: vertical ? 0 : 12, height: vertical ? 12 : 0),
      Flexible(
        fit: FlexFit.loose,
        child: ButtonWidget(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          label: confirmLabel,
          style: confirmStyle,
          isFullWidth: true,
        ),
      ),
    ];

    return DialogWidget(
      title: title,
      message: message,
      icon: icon,
      iconColor: confirmStyle.backgroundColor,
      actions: vertical
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: children.reversed.toList(),
            )
          : Row(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}
