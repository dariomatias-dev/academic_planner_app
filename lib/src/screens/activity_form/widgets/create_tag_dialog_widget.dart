import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/validators.dart';

import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/dialog_widget.dart';
import 'package:academic_planner/src/shared/widgets/inputs/input_widget.dart';

class CreateTagDialogWidget extends StatefulWidget {
  final Function(String value) onTagAdded;

  const CreateTagDialogWidget({super.key, required this.onTagAdded});

  @override
  State<CreateTagDialogWidget> createState() => _CreateTagDialogWidgetState();
}

class _CreateTagDialogWidgetState extends State<CreateTagDialogWidget> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onTagAdded(_controller.text.trim());

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
      title: "Nova Tag",
      message: "Crie uma etiqueta personalizada.",
      icon: Icons.style_rounded,
      actions: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            InputWidget(
              controller: _controller,
              hint: "Nome da tag",
              style: InputStyle.secondary,
              validator: (value) {
                return Validators.required(
                  value,
                  message: "O nome da tag é obrigatório",
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
                    label: "Salvar",
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
