import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/app_colors.dart';

class SwitchWidget extends StatelessWidget {
  const SwitchWidget({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.primary,
      activeTrackColor: AppColors.primary.withAlpha(80),
      trackColor: const WidgetStatePropertyAll(AppColors.white),
      trackOutlineColor: const WidgetStatePropertyAll(AppColors.black),
      trackOutlineWidth: const WidgetStatePropertyAll(0.5),
      inactiveThumbColor: Colors.grey.shade400,
      inactiveTrackColor: Colors.grey.withAlpha(60),
    );
  }
}
