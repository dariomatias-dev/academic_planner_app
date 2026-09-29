import 'package:app_ui/src/components/buttons/button/button_widget.dart';
import 'package:app_ui/src/components/dialogs/dialog_widget.dart';
import 'package:flutter/material.dart';

class ErrorDialogWidget extends StatelessWidget {
  const ErrorDialogWidget({
    required this.title,
    required this.message,
    required this.buttonLabel,
    super.key,
    this.onClose,
  });

  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback? onClose;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    required String buttonLabel,
    VoidCallback? onClose,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return ErrorDialogWidget(
          title: title,
          message: message,
          buttonLabel: buttonLabel,
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
