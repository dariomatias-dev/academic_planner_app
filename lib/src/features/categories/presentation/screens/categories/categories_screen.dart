import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/features/categories/data/models/category_model.dart';
import 'package:academic_planner/src/features/categories/di/category_providers.dart';

import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/inputs/input_widget.dart';
import 'package:academic_planner/src/shared/widgets/forms/forms.dart';
import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/dialog_widget.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  void _showCategoryDialog({CategoryModel? category, int? index}) {
    final controller = TextEditingController(text: category?.name);
    final isEditing = category != null;

    showDialog(
      context: context,
      builder: (context) {
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
              InputWidget(controller: controller, hint: "Ex: Pesquisa"),
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
                      onPressed: () async {
                        final name = controller.text.trim();
                        if (name.isNotEmpty) {
                          final notifier = ref.read(
                            categoriesProvider.notifier,
                          );

                          final result = isEditing
                              ? await notifier.update(index!, name)
                              : await notifier.add(name);

                          result.when(
                            onSuccess: (_) {
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            },
                            onFailure: (failure) {
                              Fluttertoast.showToast(msg: failure.message);
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) {
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
                  onPressed: () async {
                    await ref.read(categoriesProvider.notifier).remove(index);

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: "Categorias",
        actions: <Widget>[
          IconButtonWidget(
            icon: Icons.add_rounded,
            onPressed: () => _showCategoryDialog(),
            style: IconButtonStyle.primary,
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 120.0),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(28.0),
              border: Border.all(
                color:
                    Theme.of(context).dividerTheme.color ?? Colors.transparent,
              ),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 54.0,
                  height: 54.0,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha(20),
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Icon(
                    Icons.folder_open_rounded,
                    color: colorScheme.primary,
                    size: 22.0,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    category.name,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 16.0,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () =>
                          _showCategoryDialog(category: category, index: index),
                      icon: Icon(
                        Icons.edit_outlined,
                        size: 20.0,
                        color: colorScheme.onSurface.withAlpha(120),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _confirmDelete(index),
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        size: 20.0,
                        color: colorScheme.error.withAlpha(180),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
