import 'package:flutter/material.dart';

import 'package:academic_planner/src/shared/widgets/buttons/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/dialog_widget.dart';

class CreateTagDialogWidget extends StatefulWidget {
  final Function(String value) onTagAdded;

  const CreateTagDialogWidget({super.key, required this.onTagAdded});

  @override
  State<CreateTagDialogWidget> createState() => _CreateTagDialogWidgetState();
}

class _CreateTagDialogWidgetState extends State<CreateTagDialogWidget> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DialogWidget(
      title: "Nova Tag",
      message: "Crie uma etiqueta personalizada.",
      icon: Icons.style_rounded,
      actions: Column(
        children: <Widget>[
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: "Nome da tag",
              filled: true,
              fillColor: theme.scaffoldBackgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide.none,
              ),
            ),
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
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      widget.onTagAdded(_controller.text);

                      Navigator.pop(context);
                    }
                  },
                  label: "Salvar",
                  isFullWidth: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
