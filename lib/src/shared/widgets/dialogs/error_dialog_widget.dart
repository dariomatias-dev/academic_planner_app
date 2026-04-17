import 'package:flutter/material.dart';

import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/dialog_widget.dart';

class ErrorDialogWidget extends StatelessWidget {
  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback? onClose;

  const ErrorDialogWidget({
    super.key,
    this.title = "Ops! Algo deu errado",
    required this.message,
    this.buttonLabel = "Entendido",
    this.onClose,
  });

  static void show(
    BuildContext context, {
    String? title,
    required String message,
    String? buttonLabel,
    VoidCallback? onClose,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return ErrorDialogWidget(
          title: title ?? "Ops! Algo deu errado",
          message: message,
          buttonLabel: buttonLabel ?? "Entendido",
          onClose: onClose,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DialogWidget(
      title: title,
      message: message,
      icon: Icons.error_outline_rounded,
      iconColor: colorScheme.error,
      actions: ButtonWidget(
        onPressed: () {
          Navigator.pop(context);

          onClose?.call();
        },
        label: buttonLabel,
        style: AppButtonStyle.primary,
        isFullWidth: true,
      ),
    );
  }
}
