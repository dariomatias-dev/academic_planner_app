import 'package:flutter/material.dart';

import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';

class NotificationButtonWidget extends StatelessWidget {
  const NotificationButtonWidget({super.key});

  final hasNotification = false;

  void handlePressed() {}

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        IconButtonWidget(
          icon: Icons.notifications_none_rounded,
          onPressed: handlePressed,
          style: IconButtonStyle.primary,
        ),
        if (hasNotification)
          Positioned(
            top: -2.0,
            right: -2.0,
            child: Container(
              width: 10.0,
              height: 10.0,
              decoration: BoxDecoration(
                color: colorScheme.error,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
