import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/features/categories/di/category_providers.dart';

import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/dialog_widget.dart';

class CategoryDeleteDialogWidget extends ConsumerWidget {
  final int index;

  const CategoryDeleteDialogWidget({super.key, required this.index});

  static Future<void> show(BuildContext context, {required int index}) {
    return showDialog(
      context: context,
      builder: (_) {
        return CategoryDeleteDialogWidget(index: index);
      },
    );
  }

  Future<void> _handleDelete(BuildContext context, WidgetRef ref) async {
    await ref.read(categoriesProvider.notifier).remove(index);

    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DialogWidget(
      title: "Excluir Categoria",
      message:
          "Tem certeza que deseja remover esta categoria? Esta ação não pode ser desfeita.",
      icon: Icons.delete_outline_rounded,
      iconColor: Theme.of(context).colorScheme.error,
      actions: Row(
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
              label: "Excluir",
              style: AppButtonStyle.destructiveSolid,
              onPressed: () => _handleDelete(context, ref),
            ),
          ),
        ],
      ),
    );
  }
}
