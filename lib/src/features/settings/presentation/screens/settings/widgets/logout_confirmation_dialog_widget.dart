import 'package:academic_planner/src/features/auth/di/auth_providers.dart';
import 'package:academic_planner/src/shared/widgets/buttons/buttons.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/confirmation_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LogoutConfirmationDialogWidget extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return ConfirmationDialogWidget(
      icon: Icons.logout_rounded,
      iconColor: Theme.of(context).colorScheme.error,
      title: 'Sair da Conta',
      message:
          'Tem certeza que deseja encerrar sua sessão no Academic Planner?',
      confirmLabel: 'Sair',
      confirmStyle: AppButtonStyle.destructiveSolid,
      onConfirm: () async {
        await ref.read(authNotifierProvider.notifier).signOut();

        if (context.mounted) {
          await Fluttertoast.showToast(msg: 'Sessão encerrada com sucesso');
        }
      },
    );
  }
}
