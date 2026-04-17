import 'package:flutter/material.dart';

import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/confirmation_dialog_widget.dart';

class FinalDeleteAccountConfirmationDialogWidget extends StatelessWidget {
  const FinalDeleteAccountConfirmationDialogWidget({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const FinalDeleteAccountConfirmationDialogWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ConfirmationDialogWidget(
      title: "Confirmação Final",
      message:
          "Esta é a última etapa. Ao confirmar, não haverá como recuperar suas informações. Deseja mesmo prosseguir com a exclusão?",
      icon: Icons.delete_forever_rounded,
      iconColor: colorScheme.error,
      confirmLabel: "Excluir Permanentemente",
      confirmStyle: AppButtonStyle.destructiveSolid,
      vertical: true,
      onConfirm: () {},
    );
  }
}
