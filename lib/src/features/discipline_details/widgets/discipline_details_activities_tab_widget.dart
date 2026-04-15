import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/controllers/activity_controller.dart';

import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';
import 'package:academic_planner/src/core/providers/activity_providers.dart';

import 'package:academic_planner/src/core/providers/navigation_provider.dart';

import 'package:academic_planner/src/data/filters/activity_filter.dart';

import 'package:academic_planner/src/features/activities/widgets/activities_metric_card_widget.dart';

import 'package:academic_planner/src/shared/models/activity_model.dart';
import 'package:academic_planner/src/shared/widgets/activity_card/activity_card_widget.dart';
import 'package:academic_planner/src/shared/widgets/buttons/view_all_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/empty_state_widget.dart';

class DisciplineDetailsActivitiesTabWidget extends ConsumerStatefulWidget {
  final int disciplineId;

  const DisciplineDetailsActivitiesTabWidget({
    super.key,
    required this.disciplineId,
  });

  @override
  ConsumerState<DisciplineDetailsActivitiesTabWidget> createState() =>
      _DisciplineDetailsActivitiesTabWidgetState();
}

class _DisciplineDetailsActivitiesTabWidgetState
    extends ConsumerState<DisciplineDetailsActivitiesTabWidget> {
  late final ActivityController _activityController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _activityController = ref.read(activityControllerProvider);
  }

  bool _isUrgent(ActivityModel activity) {
    if (activity.dueDate == null ||
        activity.status == ActivityStatus.completed) {
      return false;
    }

    final now = DateTime.now();
    final difference = activity.dueDate!.difference(now);

    return difference.inDays <= 3;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FutureBuilder(
      future: _activityController.getActivities(
        filter: ActivityFilter(disciplineId: widget.disciplineId),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final result = snapshot.data;

        final disciplineActivities =
            result?.fold(
              onSuccess: (list) => list,
              onFailure: (_) => <ActivityModel>[],
            ) ??
            <ActivityModel>[];

        if (disciplineActivities.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.assignment_outlined,
            title: "Sem atividades",
            description: "Nenhuma atividade criada para esta disciplina.",
            actionLabel: "Criar Atividade",
            onActionPressed: () {
              AppRoutes.goToActivityForm(
                context,
                disciplineId: widget.disciplineId,
              );
            },
          );
        }

        final completed = disciplineActivities
            .where((t) => t.status == ActivityStatus.completed)
            .length;

        final active = disciplineActivities
            .where(
              (t) =>
                  t.status == ActivityStatus.pending ||
                  t.status == ActivityStatus.inProgress,
            )
            .length;

        final urgentCount = disciplineActivities
            .where((t) => _isUrgent(t))
            .length;

        final priorityList = disciplineActivities.filter(
          (t) => t.status != ActivityStatus.completed,
        );

        priorityList.sort((a, b) {
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });

        final sortedFullList = List<ActivityModel>.from(disciplineActivities);

        sortedFullList.sort((a, b) {
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });

        return ListView(
          padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 100.0),
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: ActivitiesMetricCardWidget(
                    label: "Ativas",
                    value: active.toString(),
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
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer.withAlpha(40),
                borderRadius: BorderRadius.circular(24.0),
                border: Border.all(color: colorScheme.error.withAlpha(20)),
              ),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.notification_important_rounded,
                    color: colorScheme.error,
                  ),
                  const SizedBox(width: 16.0),
                  Text(
                    "Atividades Urgentes",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.error,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    urgentCount.toString(),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w900,
                      color: colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
            if (priorityList.isNotEmpty) ...<Widget>[
              const SizedBox(height: 40.0),
              const _SectionHeader(title: "Prioridade"),
              const SizedBox(height: 16.0),
              ...priorityList
                  .take(3)
                  .map((a) => ActivityCardWidget(activity: a)),
            ],
            const SizedBox(height: 40.0),
            _SectionHeader(
              title: "Todas as Atividades",
              action: ViewAllButtonWidget(
                onTap: () {
                  Navigator.pop(context);
                  ref.read(navigationNotifierProvider.notifier).setIndex(2);
                },
              ),
            ),
            const SizedBox(height: 16.0),
            ...sortedFullList.map((a) => ActivityCardWidget(activity: a)),
          ],
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget? action;

  const _SectionHeader({required this.title, this.action});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: <Widget>[
        Container(
          width: 4.0,
          height: 18.0,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(2.0),
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Text(
            title.toUpperCase(),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.0,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
              letterSpacing: 0.5,
            ),
          ),
        ),
        ?action,
      ],
    );
  }
}
