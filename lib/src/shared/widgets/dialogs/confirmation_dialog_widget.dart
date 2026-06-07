import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/dialog_widget.dart';
import 'package:flutter/material.dart';

class ConfirmationDialogWidget extends StatelessWidget {
  const ConfirmationDialogWidget({
    required this.title,
    required this.message,
    required this.onConfirm,
    super.key,
    this.icon,
    this.iconColor,
    this.vertical = false,
    this.confirmLabel = 'Confirmar',
    this.cancelLabel = 'Cancelar',
    this.confirmStyle = AppButtonStyle.primary,
  });

  final IconData? icon;
  final Color? iconColor;
  final String title;
  final String message;
  final bool vertical;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final AppButtonStyle confirmStyle;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      Flexible(
        child: ButtonWidget(
          onPressed: () => Navigator.pop(context),
          label: cancelLabel,
          style: AppButtonStyle.neutral,
          isFullWidth: true,
        ),
      ),
      SizedBox(width: vertical ? 0 : 12, height: vertical ? 12.0 : 0.0),
      Flexible(
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
      iconColor: iconColor,
      actions: vertical
          ? Column(mainAxisSize: MainAxisSize.min, children: children.reverse())
          : Row(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}
