import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/app_colors.dart';

enum IconButtonStyle { primary, secondary, neutral, outline }

class IconButtonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final double? iconSize;
  final IconButtonStyle style;

  const IconButtonWidget({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 48.0,
    this.iconSize,
    this.style = IconButtonStyle.neutral,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    late Color backgroundColor;
    late Color iconColor;
    Color? borderColor;

    switch (style) {
      case IconButtonStyle.primary:
        backgroundColor = colorScheme.primary.withAlpha(20);
        iconColor = colorScheme.primary;
        break;
      case IconButtonStyle.secondary:
        backgroundColor = colorScheme.primary.withAlpha(25);
        iconColor = colorScheme.primary;
        break;
      case IconButtonStyle.neutral:
        backgroundColor = theme.scaffoldBackgroundColor;
        iconColor = colorScheme.onSurface;
        break;
      case IconButtonStyle.outline:
        backgroundColor = AppColors.transparent;
        iconColor = colorScheme.onSurface;
        borderColor = theme.dividerTheme.color;
        break;
    }

    return IconButton(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor,
        fixedSize: Size(size, size),
        minimumSize: Size(size, size),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: borderColor != null
              ? BorderSide(color: borderColor, width: 1.0)
              : BorderSide.none,
        ),
      ),
      icon: Icon(icon, color: iconColor, size: iconSize ?? (size * 0.58)),
    );
  }
}
