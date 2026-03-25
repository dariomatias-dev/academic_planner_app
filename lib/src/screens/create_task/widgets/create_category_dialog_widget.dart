import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/app_colors.dart';

import 'package:academic_planner/src/shared/widgets/buttons/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/dialog_widget.dart';

class CreateCategoryDialogWidget extends StatefulWidget {
  final Function(String value) onCategoryAdded;

  const CreateCategoryDialogWidget({super.key, required this.onCategoryAdded});

  @override
  State<CreateCategoryDialogWidget> createState() => _CreateCategoryDialogWidgetState();
}

class _CreateCategoryDialogWidgetState extends State<CreateCategoryDialogWidget> {
  final _controller = TextEditingController();

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
      actions: Column(
        children: <Widget>[
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: "Nome da categoria",
              filled: true,
              fillColor: AppColors.bg,
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
                  style: ButtonStyles.neutral,
                  label: 'Cancelar',
                  isFullWidth: true,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: ButtonWidget(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      widget.onCategoryAdded(_controller.text);

                      Navigator.pop(context);
                    }
                  },
                  label: "Adicionar",
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
