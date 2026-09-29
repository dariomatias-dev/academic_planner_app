import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class DisciplineSelectionCheckIconWidget extends StatelessWidget {
  const DisciplineSelectionCheckIconWidget({
    required this.isSelected,
    super.key,
  });

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 28.0,
      height: 28.0,
      decoration: BoxDecoration(
        color: isSelected ? colorScheme.primary : AppPalette.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? colorScheme.primary
              : Theme.of(context).dividerTheme.color ?? AppPalette.transparent,
          width: 2.0,
        ),
      ),
      child: isSelected
          ? Icon(Icons.check_rounded, size: 18.0, color: colorScheme.onPrimary)
          : null,
    );
  }
}
