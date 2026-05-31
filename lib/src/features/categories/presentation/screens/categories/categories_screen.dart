import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/features/categories/di/category_providers.dart';
import 'package:academic_planner/src/features/categories/presentation/widgets/dialogs/category_form_dialog_widget.dart';
import 'package:academic_planner/src/shared/actions/removal_flow.dart';

import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final categories =
        ref.watch(categoriesNotifierProvider).asData?.value ?? [];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: "Categorias",
        actions: <Widget>[
          IconButtonWidget(
            icon: Icons.add_rounded,
            onPressed: () {
              CategoryFormDialogWidget.show(context);
            },
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
                      onPressed: () {
                        CategoryFormDialogWidget.show(
                          context,
                          category: category,
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
                        removalFlow(
                          context: context,
                          confirmTitle: 'Excluir Categoria',
                          confirmMessage:
                              'Tem certeza que deseja remover esta categoria? Esta ação não pode ser desfeita.',
                          onDelete: () async {
                            String? error;

                            final result = await ref
                                .read(categoriesNotifierProvider.notifier)
                                .remove(index);

                            result.when(onFailure: (f) => error = f.message);

                            return error;
                          },
                        );
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
