import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/extensions/list_extension.dart';

import 'package:academic_planner/src/shared/widgets/forms/forms.dart';
import 'package:academic_planner/src/shared/widgets/selectable_chip_widget.dart';

class ActivityFormCategorySelectorWidget extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final void Function(String? value) onSelect;
  final VoidCallback onCreate;
  final bool isRequired;

  const ActivityFormCategorySelectorWidget({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelect,
    required this.onCreate,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FormFieldLabelWidget(label: "Categoria", isRequired: isRequired),
            GestureDetector(
              onTap: onCreate,
              child: Text(
                "+ Nova Categoria",
                style: GoogleFonts.plusJakartaSans(
                  color: colorScheme.primary,
                  fontSize: 11.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 8.0,
            children: categories.builder((category, index) {
              final isSelected = selectedCategory == category;

              return SelectableChipWidget(
                onTap: () => onSelect(isSelected ? null : category),
                label: category,
                isSelected: isSelected,
              );
            }),
          ),
        ),
      ],
    );
  }
}
