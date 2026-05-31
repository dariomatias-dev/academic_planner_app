import 'package:flutter/material.dart';

import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/dialog_widget.dart';

class RemovalSuccessDialogWidget extends StatelessWidget {
  final String title;
  final String message;

  const RemovalSuccessDialogWidget({
    super.key,
    required this.title,
    required this.message,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    return showDialog(
      context: context,
      builder: (_) {
        return RemovalSuccessDialogWidget(title: title, message: message);
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
        label: 'Entendido',
        onPressed: () => Navigator.pop(context),
        style: AppButtonStyle.primary,
        isFullWidth: true,
      ),
    );
  }
}
