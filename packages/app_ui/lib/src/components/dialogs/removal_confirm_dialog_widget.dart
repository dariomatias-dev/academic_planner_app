import 'package:app_ui/src/components/buttons/button/button_widget.dart';
import 'package:app_ui/src/components/dialogs/dialog_widget.dart';
import 'package:flutter/material.dart';

class RemovalConfirmDialogWidget extends StatelessWidget {
  const RemovalConfirmDialogWidget({
    required this.title,
    required this.message,
    required this.cancelLabel,
    required this.confirmLabel,
    required this.onConfirm,
    super.key,
  });

  final String title;
  final String message;
  final String cancelLabel;
  final String confirmLabel;
  final Future<void> Function() onConfirm;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    required String cancelLabel,
    required String confirmLabel,
    required Future<void> Function() onConfirm,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return RemovalConfirmDialogWidget(
          title: title,
          message: message,
          cancelLabel: cancelLabel,
          confirmLabel: confirmLabel,
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
        children: [
          Expanded(
            child: ButtonWidget(
              label: cancelLabel,
              style: AppButtonStyle.neutral,
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: ButtonWidget(
              label: confirmLabel,
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
