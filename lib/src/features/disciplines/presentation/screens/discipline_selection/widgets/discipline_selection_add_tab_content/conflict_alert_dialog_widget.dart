import 'package:academic_planner/src/shared/widgets/buttons/buttons.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/dialog_widget.dart';
import 'package:flutter/material.dart';

class ConflictAlertDialogWidget extends StatelessWidget {
  const ConflictAlertDialogWidget({
    required this.targetDisciplineName,
    required this.conflictDetails,
    super.key,
  });

  final String targetDisciplineName;
  final String conflictDetails;

  static Future<void> show(
    BuildContext context, {
    required String targetDisciplineName,
    required String conflictDetails,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
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
      title: 'Conflito de Horário',
      icon: Icons.error_outline_rounded,
      iconColor: Theme.of(context).colorScheme.error,
      message:
          "Não foi possível adicionar '$targetDisciplineName' devido aos "
          'seguintes conflitos:\n\n$conflictDetails',
      actions: ButtonWidget(
        onPressed: () => Navigator.pop(context),
        label: 'Entendi',
        style: AppButtonStyle.neutral,
        isFullWidth: true,
      ),
    );
  }
}
