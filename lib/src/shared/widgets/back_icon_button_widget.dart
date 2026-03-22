import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/app_colors.dart';

import 'package:academic_planner/src/shared/widgets/icon_button_widget.dart';

class BackIconButtonWidget extends StatelessWidget {
  const BackIconButtonWidget({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButtonWidget(
      icon: Icons.chevron_left_rounded,
      onPressed: onPressed ?? () => Navigator.pop(context),
      backgroundColor: AppColors.bg,
      iconColor: AppColors.textMain,
      borderColor: AppColors.borderMedium,
      size: 48.0,
      iconSize: 28.0,
    );
  }
}
