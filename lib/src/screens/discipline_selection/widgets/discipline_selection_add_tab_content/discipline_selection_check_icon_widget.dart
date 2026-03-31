import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/app_colors.dart';

class DisciplineSelectionCheckIconWidget extends StatelessWidget {
  final bool isSelected;

  const DisciplineSelectionCheckIconWidget({
    super.key,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 28.0,
      height: 28.0,
      decoration: BoxDecoration(
        color: isSelected ? colorScheme.primary : AppColors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? colorScheme.primary
              : Theme.of(context).dividerTheme.color ?? AppColors.transparent,
          width: 2.0,
        ),
      ),
      child: isSelected
          ? Icon(Icons.check_rounded, size: 18.0, color: colorScheme.onPrimary)
          : null,
    );
  }
}
