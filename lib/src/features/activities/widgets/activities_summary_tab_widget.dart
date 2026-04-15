import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/features/activities/widgets/activities_metric_card_widget.dart';

import 'package:academic_planner/src/shared/models/activity_model.dart';
import 'package:academic_planner/src/shared/widgets/activity_card/activity_card_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/empty_state_widget.dart';

class ActivitiesSummaryTabWidget extends StatelessWidget {
  final List<ActivityModel> tasks;

  const ActivitiesSummaryTabWidget({super.key, required this.tasks});

  bool _isUrgent(ActivityModel task) {
    if (task.dueDate == null || task.status == ActivityStatus.completed) {
      return false;
    }

    final now = DateTime.now();
    final difference = task.dueDate!.difference(now);

    return difference.inDays <= 3;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final completed = tasks
        .where((t) => t.status == ActivityStatus.completed)
        .length;

    final pending = tasks
        .where(
          (t) =>
              t.status == ActivityStatus.pending ||
              t.status == ActivityStatus.inProgress,
        )
        .length;

    final urgent = tasks.where((t) => _isUrgent(t)).length;
    final total = tasks.length;
    final progress = total == 0 ? 0.0 : completed / total;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 140.0),
      physics: const BouncingScrollPhysics(),
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(24.0),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: colorScheme.primary.withAlpha(60),
                      blurRadius: 20.0,
                      offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Seu Progresso",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onPrimary.withAlpha(200),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "${(progress * 100).toInt()}%",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 32.0,
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8.0,
                        backgroundColor: colorScheme.onPrimary.withAlpha(50),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              flex: 2,
              child: Container(
                height: 145.0,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.notification_important_rounded,
                      color: colorScheme.error,
                      size: 28.0,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      urgent.toString(),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w800,
                        color: colorScheme.error,
                      ),
                    ),
                    Text(
                      "URGENTES",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.error.withAlpha(180),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        Row(
          children: <Widget>[
            Expanded(
              child: ActivitiesMetricCardWidget(
                label: "Ativas",
                value: pending.toString(),
                icon: Icons.bolt_rounded,
                color: colorScheme.secondary,
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: ActivitiesMetricCardWidget(
                label: "Concluídas",
                value: completed.toString(),
                icon: Icons.check_circle_rounded,
                color: Colors.teal,
              ),
            ),
          ],
        ),
        const SizedBox(height: 40.0),
        Row(
          children: <Widget>[
            Container(
              width: 4.0,
              height: 22.0,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
            const SizedBox(width: 12.0),
            Text(
              "Próximos Prazos",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18.0,
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20.0),
        if (tasks.where((t) => t.status != ActivityStatus.completed).isEmpty)
          EmptyStateWidget(
            icon: Icons.celebration_rounded,
            title: 'Sem atividades',
            description: 'Tudo em dia por aqui!',
            isCentered: false,
          )
        else
          ...tasks
              .where((t) => t.status != ActivityStatus.completed)
              .take(3)
              .map((task) => ActivityCardWidget(activity: task)),
      ],
    );
  }
}
