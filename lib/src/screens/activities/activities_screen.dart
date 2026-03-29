import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/constants/mock_activities.dart';

import 'package:academic_planner/src/shared/widgets/activity_card_widget.dart';
import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';

class ActivitiesScreenWidget extends StatelessWidget {
  const ActivitiesScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const AppBarWidget(title: "Tarefas"),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 120.0),
        itemCount: mockActivities.length,
        itemBuilder: (context, index) {
          return ActivityCardWidget(activity: mockActivities[index]);
        },
      ),
    );
  }
}
