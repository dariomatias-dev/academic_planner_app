import 'package:flutter/material.dart';

import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/dialog_widget.dart';

class NoteRemovalSuccessDialogWidget extends StatelessWidget {
  const NoteRemovalSuccessDialogWidget({super.key});

  static Future<void> show(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return const NoteRemovalSuccessDialogWidget();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      title: "Anotação Removida",
      message: "A anotação foi excluída com sucesso da sua base de dados.",
      icon: Icons.check_circle_outline_rounded,
      iconColor: Colors.teal,
      actions: ButtonWidget(
        label: "Entendido",
        onPressed: () => Navigator.pop(context),
        style: AppButtonStyle.primary,
        isFullWidth: true,
      ),
    );
  }
}
