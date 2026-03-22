import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/app_colors.dart';

class IconButtonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color iconColor;
  final Color? borderColor;
  final double size;
  final double? iconSize;

  const IconButtonWidget({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor = AppColors.bg,
    this.iconColor = AppColors.textMain,
    this.borderColor,
    this.size = 48.0,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor,
        fixedSize: Size(size, size),
        minimumSize: Size(size, size),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: borderColor != null
              ? BorderSide(color: borderColor!, width: 1.0)
              : BorderSide.none,
        ),
      ),
      icon: Icon(icon, color: iconColor, size: iconSize ?? (size * 0.58)),
    );
  }
}
