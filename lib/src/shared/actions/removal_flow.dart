import 'package:academic_planner/src/core/errors/result.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

Future<String?> resultToError<T>(Future<Result<T>> resultFuture) async {
  final result = await resultFuture;

  return result.fold(
    onSuccess: (_) => null,
    onFailure: (f) => f.message,
  );
}

/// Orchestrates the full delete UX: confirm → delete → success/failure with retry.
///
/// [onDelete] returns null on success or an error message on failure.
/// [onSuccess] is called after the success dialog is dismissed
/// (or immediately after deletion if no success dialog).
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
      'Não conseguimos remover o item no momento.'
      ' Por favor, tente novamente em instantes.',
}) async {
  var success = false;

  final navigator = Navigator.of(context, rootNavigator: true);
  final overlayContext = navigator.context;

  String? errorMessage;

  Future<bool> attemptDelete() async {
    errorMessage = await onDelete();

    return errorMessage == null;
  }

  Future<bool> showRetryDialog() async {
    var retry = false;

    await RemovalFailureDialogWidget.show(
      overlayContext,
      title: 'Ops! Algo deu errado',
      retryLabel: 'Tentar Novamente',
      closeLabel: 'Fechar',
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
            buttonLabel: 'Entendido',
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
    cancelLabel: 'Cancelar',
    confirmLabel: 'Excluir',
    title: confirmTitle,
    message: confirmMessage,
    onConfirm: onConfirm,
  );

  return success;
}
