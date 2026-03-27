import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/app_colors.dart';

class IconButtonStyles {
  final Color backgroundColor;
  final Color iconColor;
  final Color? borderColor;

  const IconButtonStyles({
    required this.backgroundColor,
    required this.iconColor,
    this.borderColor,
  });

  static final primary = IconButtonStyles(
    backgroundColor: AppColors.primary.withAlpha(20),
    iconColor: AppColors.primary,
  );

  static final secondary = IconButtonStyles(
    backgroundColor: AppColors.primary.withAlpha(25),
    iconColor: AppColors.primary,
  );

  static const neutral = IconButtonStyles(
    backgroundColor: AppColors.bg,
    iconColor: AppColors.textMain,
  );

  static const outline = IconButtonStyles(
    backgroundColor: Colors.transparent,
    iconColor: AppColors.textMain,
    borderColor: AppColors.borderMedium,
  );
}

class IconButtonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final double? iconSize;
  final IconButtonStyles style;

  const IconButtonWidget({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 48.0,
    this.iconSize,
    this.style = IconButtonStyles.neutral,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: style.backgroundColor,
        fixedSize: Size(size, size),
        minimumSize: Size(size, size),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: style.borderColor != null
              ? BorderSide(color: style.borderColor!, width: 1.0)
              : BorderSide.none,
        ),
      ),
      icon: Icon(icon, color: style.iconColor, size: iconSize ?? (size * 0.58)),
    );
  }
}
