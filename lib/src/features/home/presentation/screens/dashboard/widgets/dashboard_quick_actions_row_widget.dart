import 'package:academic_planner/src/core/routes/app_routes.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class DashboardQuickActionsRowWidget extends StatelessWidget {
  const DashboardQuickActionsRowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ActionButtonWidget(
          onPressed: () async {
            await AppRoutes.goToActivityForm(context);
          },
          icon: Icons.add_rounded,
          label: 'Nova Tarefa',
          style: AppButtonStyle.primary,
        ),
        const SizedBox(width: 16.0),
        ActionButtonWidget(
          onPressed: () async {
            await AppRoutes.goToAgenda(context);
          },
          icon: Icons.calendar_today_rounded,
          label: 'Agenda',
          style: AppButtonStyle.neutral,
        ),
      ],
    );
  }
}
