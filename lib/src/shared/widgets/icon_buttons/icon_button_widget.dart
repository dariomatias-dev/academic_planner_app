import 'package:academic_planner/src/core/app_colors.dart';
import 'package:flutter/material.dart';

enum IconButtonStyle { primary, secondary, neutral, outline }

class IconButtonWidget extends StatelessWidget {
  const IconButtonWidget({
    required this.icon,
    required this.onPressed,
    super.key,
    this.size = 48.0,
    this.iconSize,
    this.style = IconButtonStyle.neutral,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final double? iconSize;
  final IconButtonStyle style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDisabled = onPressed == null;
    final isDark = theme.brightness == Brightness.dark;

    late Color backgroundColor;
    late Color iconColor;
    Color? borderColor;

    if (isDisabled) {
      backgroundColor = colorScheme.onSurface.withAlpha(12);
      iconColor = colorScheme.onSurface.withAlpha(60);

      if (style == IconButtonStyle.outline) {
        borderColor = theme.dividerTheme.color?.withAlpha(40);
      }
    } else {
      switch (style) {
        case IconButtonStyle.primary:
          backgroundColor = colorScheme.primary.withAlpha(isDark ? 30 : 20);
          iconColor = colorScheme.primary;
        case IconButtonStyle.secondary:
          backgroundColor = colorScheme.primary.withAlpha(isDark ? 45 : 25);
          iconColor = colorScheme.primary;
        case IconButtonStyle.neutral:
          backgroundColor = colorScheme.onSurface.withAlpha(12);
          iconColor = colorScheme.onSurface;
        case IconButtonStyle.outline:
          backgroundColor = AppColors.transparent;
          iconColor = colorScheme.onSurface;
          borderColor = theme.dividerTheme.color;
      }
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
              ? BorderSide(color: borderColor)
              : BorderSide.none,
        ),
      ),
      icon: Icon(icon, color: iconColor, size: iconSize ?? (size * 0.58)),
    );
  }
}
