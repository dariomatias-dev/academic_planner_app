import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:academic_planner/src/features/categories/data/models/category_model.dart';
import 'package:academic_planner/src/features/categories/di/category_providers.dart';

import 'package:academic_planner/src/shared/widgets/inputs/input_widget.dart';
import 'package:academic_planner/src/shared/widgets/forms/forms.dart';
import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/dialog_widget.dart';

class CategoryFormDialogWidget extends ConsumerStatefulWidget {
  final CategoryModel? category;
  final int? index;

  const CategoryFormDialogWidget({super.key, this.category, this.index});

  static Future<void> show(
    BuildContext context, {
    CategoryModel? category,
    int? index,
  }) {
    return showDialog(
      context: context,
      builder: (_) {
        return CategoryFormDialogWidget(category: category, index: index);
      },
    );
  }

  @override
  ConsumerState<CategoryFormDialogWidget> createState() =>
      _CategoryFormDialogWidgetState();
}

class _CategoryFormDialogWidgetState
    extends ConsumerState<CategoryFormDialogWidget> {
  late final _controller = TextEditingController(text: widget.category?.name);

  Future<void> _handleSave() async {
    final name = _controller.text.trim();

    if (name.isEmpty) return;

    final isEditing = widget.category != null;
    final notifier = ref.read(categoriesNotifierProvider.notifier);

    final result = isEditing
        ? await notifier.update(widget.index!, name)
        : await notifier.add(name);

    result.when(
      onSuccess: (_) {
        if (context.mounted) Navigator.pop(context);
      },
      onFailure: (failure) {
        Fluttertoast.showToast(msg: failure.message);
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.category != null;

    return DialogWidget(
      title: isEditing ? "Editar Categoria" : "Nova Categoria",
      message: "Defina um nome claro para organizar suas atividades.",
      icon: Icons.category_rounded,
      actions: Column(
        children: <Widget>[
          const FormFieldLabelWidget(
            label: "Nome da Categoria",
            isRequired: true,
          ),
          const SizedBox(height: 8.0),
          InputWidget(controller: _controller, hint: "Ex: Pesquisa"),
          const SizedBox(height: 32.0),
          Row(
            children: <Widget>[
              Expanded(
                child: ButtonWidget(
                  label: "Cancelar",
                  style: AppButtonStyle.neutral,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: ButtonWidget(
                  label: "Salvar",
                  style: AppButtonStyle.primary,
                  onPressed: _handleSave,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
