import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/app_colors.dart';

import 'package:academic_planner/src/shared/widgets/buttons/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/dialog_widget.dart';

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

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
              hintStyle: TextStyle(color: colorScheme.onSurface.withAlpha(100)),
              filled: true,
              fillColor: theme.scaffoldBackgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide(
                  color: theme.dividerTheme.color ?? AppColors.transparent,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide(
                  color: theme.dividerTheme.color ?? AppColors.transparent,
                ),
              ),
            ),
            style: TextStyle(color: colorScheme.onSurface),
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
