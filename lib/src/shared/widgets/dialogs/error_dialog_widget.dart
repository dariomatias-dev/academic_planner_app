import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/dialog_widget.dart';
import 'package:flutter/material.dart';

class ErrorDialogWidget extends StatelessWidget {
  const ErrorDialogWidget({
    required this.message,
    super.key,
    this.title = 'Ops! Algo deu errado',
    this.buttonLabel = 'Entendido',
    this.onClose,
  });

  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback? onClose;

  static Future<void> show(
    BuildContext context, {
    required String message,
    String? title,
    String? buttonLabel,
    VoidCallback? onClose,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return ErrorDialogWidget(
          title: title ?? 'Ops! Algo deu errado',
          message: message,
          buttonLabel: buttonLabel ?? 'Entendido',
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
        isFullWidth: true,
      ),
    );
  }
}
