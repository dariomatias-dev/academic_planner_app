import 'package:app_ui/src/components/buttons/button/button_widget.dart';
import 'package:app_ui/src/components/dialogs/dialog_widget.dart';
import 'package:app_ui/src/typography/app_typography.dart';
import 'package:flutter/material.dart';

class RemovalFailureDialogWidget extends StatelessWidget {
  const RemovalFailureDialogWidget({
    required this.title,
    required this.message,
    required this.retryLabel,
    required this.closeLabel,
    super.key,
    this.onRetry,
    this.errorMessage,
  });

  final String title;
  final String message;
  final String retryLabel;
  final String closeLabel;
  final VoidCallback? onRetry;
  final String? errorMessage;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    required String retryLabel,
    required String closeLabel,
    VoidCallback? onRetry,
    String? errorMessage,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return RemovalFailureDialogWidget(
          title: title,
          message: message,
          retryLabel: retryLabel,
          closeLabel: closeLabel,
          onRetry: onRetry,
          errorMessage: errorMessage,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DialogWidget(
      title: title,
      message: message,
      icon: Icons.error_outline_rounded,
      iconColor: colorScheme.error,
      actions: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (errorMessage != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: colorScheme.error.withAlpha(15),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: colorScheme.error.withAlpha(40)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16.0,
                    color: colorScheme.error,
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Text(
                      errorMessage!,
                      style: AppTypography.style(
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
          if (onRetry != null) ...[
            ButtonWidget(
              label: retryLabel,
              onPressed: () {
                Navigator.pop(context);

                onRetry!();
              },
              isFullWidth: true,
            ),
            const SizedBox(height: 12.0),
          ],
          ButtonWidget(
            label: closeLabel,
            onPressed: () => Navigator.pop(context),
            style: AppButtonStyle.neutral,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }
}
