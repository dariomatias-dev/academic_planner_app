import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/routes/app_routes.dart';

import 'package:academic_planner/src/shared/widgets/buttons/buttons.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/confirmation_dialog_widget.dart';

class LogoutConfirmationDialogWidget extends StatelessWidget {
  const LogoutConfirmationDialogWidget({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) {
        return const LogoutConfirmationDialogWidget();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialogWidget(
      icon: Icons.logout_rounded,
      iconColor: Theme.of(context).colorScheme.error,
      title: "Sair da Conta",
      message:
          "Tem certeza que deseja encerrar sua sessão no Academic Planner?",
      confirmLabel: "Sair",
      confirmStyle: AppButtonStyle.destructiveSolid,
      onConfirm: () {
        AppRoutes.goToLogin(context, replace: true);
      },
    );
  }
}
