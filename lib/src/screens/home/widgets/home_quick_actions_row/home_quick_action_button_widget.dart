import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/app_colors.dart';

import 'package:academic_planner/src/shared/widgets/buttons/button_widget.dart';

class HomeQuickActionButtonWidget extends StatelessWidget {
  const HomeQuickActionButtonWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ButtonWidget(
        label: label,
        onPressed: onPressed,
        icon: icon,
        isFullWidth: true,
        height: 64.0,
        fontSize: 13.0,
        mainAxisAlignment: MainAxisAlignment.start,
        style: ButtonStyles(
          backgroundColor: AppColors.white,
          textColor: AppColors.textMain,
          borderColor: AppColors.borderMedium,
          iconColor: color,
          iconBackgroundColor: color.withAlpha(26),
        ),
      ),
    );
  }
}
