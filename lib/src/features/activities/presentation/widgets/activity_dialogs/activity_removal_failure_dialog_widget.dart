import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/dialog_widget.dart';

class ActivityRemovalFailureDialogWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? errorMessage;

  const ActivityRemovalFailureDialogWidget({
    super.key,
    this.onRetry,
    this.errorMessage,
  });

  static Future<void> show(
    BuildContext context, {
    VoidCallback? onRetry,
    String? errorMessage,
  }) async {
    return showDialog(
      context: context,
      builder: (context) {
        return ActivityRemovalFailureDialogWidget(
          onRetry: onRetry,
          errorMessage: errorMessage,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DialogWidget(
      title: "Ops! Algo deu errado",
      message:
          "Não conseguimos remover a atividade no momento. Por favor, tente novamente em instantes.",
      icon: Icons.error_outline_rounded,
      iconColor: colorScheme.error,
      actions: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (errorMessage != null) ...<Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: colorScheme.error.withAlpha(15),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: colorScheme.error.withAlpha(40)),
              ),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16.0,
                    color: colorScheme.error,
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Text(
                      errorMessage!,
                      style: GoogleFonts.plusJakartaSans(
                        color: colorScheme.error,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
          ],
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
