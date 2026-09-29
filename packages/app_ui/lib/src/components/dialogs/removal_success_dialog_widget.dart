import 'package:app_ui/src/components/buttons/button/button_widget.dart';
import 'package:app_ui/src/components/dialogs/dialog_widget.dart';
import 'package:flutter/material.dart';

class RemovalSuccessDialogWidget extends StatelessWidget {
  const RemovalSuccessDialogWidget({
    required this.title,
    required this.message,
    required this.buttonLabel,
    super.key,
  });

  final String title;
  final String message;
  final String buttonLabel;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    required String buttonLabel,
  }) {
    return showDialog(
      context: context,
      builder: (_) {
        return RemovalSuccessDialogWidget(
          title: title,
          message: message,
          buttonLabel: buttonLabel,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      title: title,
      message: message,
      icon: Icons.check_circle_outline_rounded,
      iconColor: Colors.teal,
      actions: ButtonWidget(
        label: buttonLabel,
        onPressed: () => Navigator.pop(context),
        isFullWidth: true,
      ),
    );
  }
}
