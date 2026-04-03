import 'package:flutter/material.dart';

import 'package:academic_planner/src/shared/widgets/buttons/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/dialog_widget.dart';

class ActivityRemovalSuccessDialogWidget extends StatelessWidget {
  const ActivityRemovalSuccessDialogWidget({super.key});

  static Future<void> show(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return const ActivityRemovalSuccessDialogWidget();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      title: "Atividade Removida",
      message:
          "A atividade foi excluída com sucesso do seu cronograma acadêmico.",
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
