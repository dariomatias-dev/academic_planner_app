import 'package:flutter/material.dart';

import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';

class ActionButtonWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final AppButtonStyle style;

  const ActionButtonWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.style,
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
        style: style,
      ),
    );
  }
}
