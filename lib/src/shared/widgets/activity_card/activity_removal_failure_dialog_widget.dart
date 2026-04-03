import 'package:flutter/material.dart';

import 'package:academic_planner/src/shared/widgets/buttons/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/dialog_widget.dart';

class ActivityRemovalFailureDialogWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const ActivityRemovalFailureDialogWidget({super.key, this.onRetry});

  static Future<void> show(
    BuildContext context, {
    VoidCallback? onRetry,
  }) async {
    return showDialog(
      context: context,
      builder: (context) {
        return ActivityRemovalFailureDialogWidget(onRetry: onRetry);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DialogWidget(
      title: "Ops! Algo deu errado",
      message:
          "Não conseguimos remover a atividade no momento. Por favor, tente novamente em instantes.",
      icon: Icons.error_outline_rounded,
      iconColor: colorScheme.error,
      actions: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (onRetry != null) ...<Widget>[
            ButtonWidget(
              label: "Tentar Novamente",
              onPressed: () {
                Navigator.pop(context);
                onRetry!();
              },
              style: AppButtonStyle.primary,
              isFullWidth: true,
            ),
            const SizedBox(height: 12.0),
          ],
          ButtonWidget(
            label: "Fechar",
            onPressed: () => Navigator.pop(context),
            style: AppButtonStyle.neutral,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }
}
