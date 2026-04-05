import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/app_validators.dart';

import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/dialog_widget.dart';
import 'package:academic_planner/src/shared/widgets/input_widget.dart';

class CreateCategoryDialogWidget extends StatefulWidget {
  final Function(String value) onCategoryAdded;

  const CreateCategoryDialogWidget({super.key, required this.onCategoryAdded});

  @override
  State<CreateCategoryDialogWidget> createState() =>
      _CreateCategoryDialogWidgetState();
}

class _CreateCategoryDialogWidgetState
    extends State<CreateCategoryDialogWidget> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onCategoryAdded(_controller.text.trim());

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      title: "Nova Categoria",
      message: "Defina um novo grupo para suas atividades.",
      icon: Icons.grid_view_rounded,
      actions: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            InputWidget(
              controller: _controller,
              hint: "Nome da categoria",
              style: InputStyle.secondary,
              validator: (value) {
                return AppValidators.required(
                  value,
                  message: "O nome da categoria é obrigatório",
                );
              },
            ),
            const SizedBox(height: 40.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: ButtonWidget(
                    onPressed: () => Navigator.pop(context),
                    style: AppButtonStyle.neutral,
                    label: 'Cancelar',
                    isFullWidth: true,
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: ButtonWidget(
                    onPressed: _submit,
                    label: "Adicionar",
                    isFullWidth: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
