import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final _categories = <String>[
    "Estudo",
    "Leitura",
    "Projeto",
    "Prova",
    "Trabalho",
  ];

  void _showCategoryDialog({String? oldCategory, int? index}) {
    final controller = TextEditingController(text: oldCategory);
    final isEditing = oldCategory != null;

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
                      onPressed: () {
                        if (controller.text.trim().isNotEmpty) {
                          setState(() {
                            if (isEditing) {
                              _categories[index!] = controller.text.trim();
                            } else {
                              _categories.add(controller.text.trim());
                            }
                          });

                          Navigator.pop(context);
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
                  onPressed: () {
                    setState(() => _categories.removeAt(index));

                    Navigator.pop(context);
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
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];

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
                    category,
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
                      onPressed: () {
                        _showCategoryDialog(
                          oldCategory: category,
                          index: index,
                        );
                      },
                      icon: Icon(
                        Icons.edit_outlined,
                        size: 20.0,
                        color: colorScheme.onSurface.withAlpha(120),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _confirmDelete(index);
                      },
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
