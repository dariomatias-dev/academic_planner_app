import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/shared/widgets/dialogs/removal_confirm_dialog_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/removal_failure_dialog_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/removal_success_dialog_widget.dart';

Future<String?> resultToError<T>(Future<Result<T>> resultFuture) async {
  String? error;

  final result = await resultFuture;

  result.when(onFailure: (f) => error = f.message);

  return error;
}

/// Orchestrates the full delete UX: confirm → delete → success/failure with retry.
///
/// [onDelete] returns null on success or an error message on failure.
/// [onSuccess] is called after the success dialog is dismissed (or immediately after deletion if no success dialog).
/// Omit [successTitle]/[successMessage] to skip the success dialog.
Future<bool> removalFlow({
  required BuildContext context,
  required String confirmTitle,
  required String confirmMessage,
  required Future<String?> Function() onDelete,
  VoidCallback? onSuccess,
  String? successTitle,
  String? successMessage,
  String failureMessage =
      'Não conseguimos remover o item no momento. Por favor, tente novamente em instantes.',
}) async {
  bool success = false;

  final navigator = Navigator.of(context, rootNavigator: true);
  final overlayContext = navigator.context;

  String? errorMessage;

  Future<bool> attemptDelete() async {
    errorMessage = await onDelete();

    return errorMessage == null;
  }

  Future<bool> showRetryDialog() async {
    bool retry = false;

    await RemovalFailureDialogWidget.show(
      overlayContext,
      message: failureMessage,
      errorMessage: errorMessage,
      onRetry: () => retry = true,
    );

    return retry;
  }

  Future<void> onConfirm() async {
    var shouldRetry = true;

    while (shouldRetry) {
      final ok = await attemptDelete();

      if (ok) {
        success = true;

        if (successTitle != null && successMessage != null) {
          if (!overlayContext.mounted) return;
          await RemovalSuccessDialogWidget.show(
            overlayContext,
            title: successTitle,
            message: successMessage,
          );
        }

        onSuccess?.call();

        if (!overlayContext.mounted) return;
        Navigator.pop(overlayContext);

        return;
      }

      if (!overlayContext.mounted) return;

      shouldRetry = await showRetryDialog();
    }

    if (overlayContext.mounted) Navigator.pop(overlayContext);
  }

  await RemovalConfirmDialogWidget.show(
    overlayContext,
    title: confirmTitle,
    message: confirmMessage,
    onConfirm: onConfirm,
  );

  return success;
}
