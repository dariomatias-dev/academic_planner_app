import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/app_colors.dart';

import 'package:academic_planner/src/screens/home/widgets/home_quick_actions_row/home_quick_action_button_widget.dart';

class HomeQuickActionsRowWidget extends StatelessWidget {
  const HomeQuickActionsRowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        HomeQuickActionButtonWidget(
          onPressed: () {},
          icon: Icons.add_rounded,
          label: "Nova Tarefa",
          color: AppColors.primary,
        ),
        SizedBox(width: 16.0),
        HomeQuickActionButtonWidget(
          onPressed: () {},
          icon: Icons.calendar_today_rounded,
          label: "Agenda",
          color: AppColors.textMain,
        ),
      ],
    );
  }
}
