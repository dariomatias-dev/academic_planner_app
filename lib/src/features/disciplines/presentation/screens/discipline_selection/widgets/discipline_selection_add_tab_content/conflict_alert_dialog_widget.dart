import 'package:flutter/material.dart';

import 'package:academic_planner/src/shared/widgets/buttons/buttons.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/dialog_widget.dart';

class ConflictAlertDialogWidget extends StatelessWidget {
  final String targetDisciplineName;
  final String conflictDetails;

  const ConflictAlertDialogWidget({
    super.key,
    required this.targetDisciplineName,
    required this.conflictDetails,
  });

  static void show(
    BuildContext context, {
    required String targetDisciplineName,
    required String conflictDetails,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return ConflictAlertDialogWidget(
          targetDisciplineName: targetDisciplineName,
          conflictDetails: conflictDetails,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      title: "Conflito de Horário",
      icon: Icons.error_outline_rounded,
      iconColor: Theme.of(context).colorScheme.error,
      message:
          "Não foi possível adicionar '$targetDisciplineName' devido aos seguintes conflitos:\n\n$conflictDetails",
      actions: ButtonWidget(
        onPressed: () => Navigator.pop(context),
        label: "Entendi",
        style: AppButtonStyle.neutral,
        isFullWidth: true,
      ),
    );
  }
}
