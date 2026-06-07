import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';
import 'package:flutter/material.dart';

class AppButtonStyles {
  const AppButtonStyles({
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    this.iconBackgroundColor,
  });

  factory AppButtonStyles.fromStyle(AppButtonStyle style, ThemeData theme) {
    final colorScheme = theme.colorScheme;

    switch (style) {
      case AppButtonStyle.primary:
        return AppButtonStyles(
          backgroundColor: colorScheme.primary,
          textColor: colorScheme.onPrimary,
        );
      case AppButtonStyle.secondary:
        return AppButtonStyles(
          backgroundColor: colorScheme.primary.withAlpha(25),
          textColor: colorScheme.primary,
        );
      case AppButtonStyle.neutral:
        return AppButtonStyles(
          backgroundColor: theme.scaffoldBackgroundColor,
          textColor: colorScheme.onSurface,
          borderColor: theme.dividerTheme.color,
        );
      case AppButtonStyle.outline:
        return AppButtonStyles(
          backgroundColor: AppColors.transparent,
          textColor: colorScheme.primary,
          borderColor: colorScheme.primary,
        );
      case AppButtonStyle.destructive:
        return AppButtonStyles(
          backgroundColor: colorScheme.errorContainer,
          textColor: colorScheme.error,
          iconBackgroundColor: colorScheme.error.withAlpha(40),
        );
      case AppButtonStyle.destructiveSolid:
        return AppButtonStyles(
          backgroundColor: colorScheme.error,
          textColor: colorScheme.onError,
        );
    }
  }

  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final Color? iconBackgroundColor;
}
