import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';

import 'package:academic_planner/src/shared/widgets/buttons/action_button_widget.dart';

class HomeQuickActionsRowWidget extends StatelessWidget {
  const HomeQuickActionsRowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ActionButtonWidget(
          onPressed: () {
            AppRoutes.goToCreateTask(context, disciplineId: 0);
          },
          icon: Icons.add_rounded,
          label: "Nova Tarefa",
          color: AppColors.primary,
        ),
        SizedBox(width: 16.0),
        ActionButtonWidget(
          onPressed: () {},
          icon: Icons.calendar_today_rounded,
          label: "Agenda",
          color: AppColors.textMain,
        ),
      ],
    );
  }
}
