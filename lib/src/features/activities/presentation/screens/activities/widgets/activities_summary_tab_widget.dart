import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/widgets/activity_section_header_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/widgets/activity_stats_cards_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/activity_card/activity_card_widget.dart';

import 'package:academic_planner/src/shared/widgets/states/empty_state_widget.dart';

class ActivitiesSummaryTabWidget extends ConsumerWidget {
  final List<Activity> activities;

  const ActivitiesSummaryTabWidget({super.key, required this.activities});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final statsAsync = ref.watch(activityStatsNotifierProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 140.0),
      physics: const BouncingScrollPhysics(),
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: ActivityProgressCardWidget(
                state: statsAsync.whenData((s) => s.progress),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              flex: 2,
              child: ActivityUrgentCardWidget(
                state: statsAsync.whenData((s) => s.urgent),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        Row(
          children: <Widget>[
            Expanded(
              child: MetricCardWidget(
                label: "Ativas",
                icon: Icons.bolt_rounded,
                color: theme.colorScheme.secondary,
                state: statsAsync.whenData((stats) {
                  return stats.active;
                }),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: MetricCardWidget(
                label: "Concluídas",
                icon: Icons.check_circle_rounded,
                color: Colors.teal,
                state: statsAsync.whenData((stats) {
                  return stats.completed;
                }),
              ),
            ),
          ],
        ),
        const SizedBox(height: 40.0),
        const ActivitySectionHeaderWidget(title: "Próximos Prazos"),
        const SizedBox(height: 20.0),
        if (activities.isEmpty)
          const EmptyStateWidget(
            icon: Icons.celebration_rounded,
            title: 'Sem atividades',
            description: 'Tudo em dia por aqui!',
            isCentered: false,
          )
        else
          ...activities.map((task) => ActivityCardWidget(activity: task)),
      ],
    );
  }
}
