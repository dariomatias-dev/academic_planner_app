import 'package:academic_planner/src/features/auth/di/auth_providers.dart';
import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/confirmation_dialog_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/error_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FinalDeleteAccountConfirmationDialogWidget extends ConsumerWidget {
  const FinalDeleteAccountConfirmationDialogWidget({super.key});

  static Future<void> show(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) => const FinalDeleteAccountConfirmationDialogWidget(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return ConfirmationDialogWidget(
      title: 'Confirmação Final',
      message:
          'Esta é a última etapa. Ao confirmar, não haverá como recuperar suas '
          'informações. Deseja mesmo prosseguir com a exclusão?',
      icon: Icons.delete_forever_rounded,
      iconColor: colorScheme.error,
      confirmLabel: 'Excluir Permanentemente',
      confirmStyle: AppButtonStyle.destructiveSolid,
      vertical: true,
      onConfirm: () async {
        try {
          await ref.read(authNotifierProvider.notifier).deleteAccount();

          if (context.mounted) {
            Navigator.pop(context);
          }

          await Fluttertoast.showToast(
            msg: 'Sua conta foi excluída com sucesso',
          );
        } on Exception catch (_) {
          if (context.mounted) {
            await ErrorDialogWidget.show(
              context,
              message:
                  'Ocorreu um erro ao tentar excluir sua conta. Por favor, '
                  'tente novamente mais tarde.',
            );
          }
        }
      },
    );
  }
}
