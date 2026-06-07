import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';
import 'package:flutter/material.dart';

class BackIconButtonWidget extends StatelessWidget {
  const BackIconButtonWidget({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButtonWidget(
      icon: Icons.chevron_left_rounded,
      onPressed: onPressed ?? () => Navigator.pop(context),
      iconSize: 28.0,
    );
  }
}
