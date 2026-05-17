import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/features/categories/di/category_providers.dart';
import 'package:academic_planner/src/shared/widgets/modal_bottom_sheet_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/empty_state_widget.dart';

class CategoryFilterSectionWidget extends ConsumerWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const CategoryFilterSectionWidget({
    super.key,
    required this.value,
    required this.onChanged,
  });

  void _openModal(BuildContext context, WidgetRef ref) {
    final categories = ref.read(categoriesNotifierProvider);

    ModalBottomSheetWidget.show(
      context: context,
      title: 'Filtrar por Categoria',
      child: _CategoryListModal(
        categories: categories.map((c) => c.name).toList(),
        selected: value,
        onSelected: (name) {
          onChanged(name == value ? null : name);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'CATEGORIA',
          style: GoogleFonts.plusJakartaSans(
            color: colorScheme.primary,
            fontSize: 11.0,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16.0),
        GestureDetector(
          onTap: () => _openModal(context, ref),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: theme.dividerTheme.color ?? AppColors.transparent,
                width: 1.0,
              ),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 44.0,
                  height: 44.0,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha(15),
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  child: Icon(
                    Icons.label_rounded,
                    color: colorScheme.primary,
                    size: 20.0,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        value ?? 'Nenhuma categoria',
                        style: GoogleFonts.plusJakartaSans(
                          color: value == null
                              ? colorScheme.onSurface.withAlpha(120)
                              : colorScheme.onSurface,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        value == null ? 'Toque para selecionar' : 'Filtro ativo',
                        style: GoogleFonts.plusJakartaSans(
                          color: colorScheme.onSurface.withAlpha(100),
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.unfold_more_rounded,
                  color: colorScheme.onSurface.withAlpha(60),
                  size: 20.0,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryListModal extends StatelessWidget {
  final List<String> categories;
  final String? selected;
  final ValueChanged<String> onSelected;

  const _CategoryListModal({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (categories.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.label_outline_rounded,
        title: 'Nenhuma categoria',
        description: 'Não há categorias cadastradas para filtragem.',
        isCentered: false,
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: categories.length,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemBuilder: (context, index) {
        final name = categories[index];
        final isSelected = selected == name;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: ListTile(
            onTap: () => onSelected(name),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: BorderSide(
                color: isSelected ? colorScheme.primary : Colors.transparent,
                width: 1.5,
              ),
            ),
            tileColor: isSelected
                ? colorScheme.primary.withAlpha(15)
                : colorScheme.onSurface.withAlpha(5),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            title: Text(
              name,
              style: GoogleFonts.plusJakartaSans(
                color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                fontSize: 14.0,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
              ),
            ),
            trailing: isSelected
                ? Icon(Icons.check_circle_rounded, color: colorScheme.primary)
                : Icon(
                    Icons.circle_outlined,
                    color: colorScheme.onSurface.withAlpha(40),
                    size: 20.0,
                  ),
          ),
        );
      },
    );
  }
}
