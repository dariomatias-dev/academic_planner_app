import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/dialog_widget.dart';
import 'package:flutter/material.dart';

class LinkOpeningFailureDialogWidget extends StatelessWidget {
  const LinkOpeningFailureDialogWidget({super.key});

  static Future<void> show(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return const LinkOpeningFailureDialogWidget();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DialogWidget(
      title: 'Não foi possível abrir',
      message:
          'Ocorreu um problema ao tentar abrir o documento no seu navegador. '
          'Por favor, tente novamente em instantes.',
      icon: Icons.link_off_rounded,
      iconColor: colorScheme.error,
      actions: ButtonWidget(
        label: 'Fechar',
        onPressed: () => Navigator.pop(context),
        style: AppButtonStyle.neutral,
        isFullWidth: true,
      ),
    );
  }
}
