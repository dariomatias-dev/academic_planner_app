import 'package:app_ui/src/colors/app_palette.dart';
import 'package:app_ui/src/typography/app_typography.dart';
import 'package:flutter/material.dart';

class FilterChipWidget extends StatelessWidget {
  const FilterChipWidget({
    required this.label,
    required this.isSelected,
    required this.onSelected,
    super.key,
  });

  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: colorScheme.surface,
      selectedColor: colorScheme.primary,
      checkmarkColor: colorScheme.onPrimary,
      labelStyle: AppTypography.style(
        color: isSelected
            ? colorScheme.onPrimary
            : colorScheme.onSurface.withAlpha(160),
        fontWeight: FontWeight.w700,
        fontSize: 12.0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      side: BorderSide(
        color: isSelected
            ? colorScheme.primary
            : (Theme.of(context).dividerTheme.color ?? AppPalette.transparent),
      ),
    );
  }
}
