import 'package:flutter/material.dart';

import 'package:academic_planner/src/shared/widgets/buttons/button_widget.dart';

class ActionButtonWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const ActionButtonWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

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
        style: AppButtonStyle.neutral,
      ),
    );
  }
}
