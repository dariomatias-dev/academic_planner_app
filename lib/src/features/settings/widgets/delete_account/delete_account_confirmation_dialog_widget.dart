import 'package:flutter/material.dart';

import 'package:academic_planner/src/features/settings/widgets/delete_account/final_delete_account_confirmation_dialog_widget.dart';

import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/confirmation_dialog_widget.dart';

class DeleteAccountConfirmationDialogWidget extends StatelessWidget {
  const DeleteAccountConfirmationDialogWidget({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const DeleteAccountConfirmationDialogWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ConfirmationDialogWidget(
      title: "Excluir Conta",
      message:
          "Você tem certeza que deseja excluir sua conta? Esta ação é irreversível e todos os seus dados serão permanentemente removidos.",
      icon: Icons.warning_amber_rounded,
      iconColor: colorScheme.error,
      confirmLabel: "Continuar",
      confirmStyle: AppButtonStyle.destructiveSolid,
      onConfirm: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FinalDeleteAccountConfirmationDialogWidget.show(context);
        });
      },
    );
  }
}
