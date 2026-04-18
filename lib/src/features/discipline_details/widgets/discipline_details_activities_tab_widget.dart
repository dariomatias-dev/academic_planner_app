import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/di/navigation_provider.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';
import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/features/activity/di/activity_providers.dart';
import 'package:academic_planner/src/features/activity/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activity/domain/value_objects/activity_filter.dart';
import 'package:academic_planner/src/features/activity/presentation/screens/activities/widgets/activities_metric_card_widget.dart';

import 'package:academic_planner/src/shared/widgets/activity_card/activity_card_widget.dart';
import 'package:academic_planner/src/shared/widgets/buttons/view_all_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/states.dart';

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
  late Future<List<Result<List<Activity>>>> _dataFuture;

  void _loadData() {
    final activityNotifier = ref.read(activityNotifierProvider.notifier);

    final now = DateTime.now();

    _dataFuture = Future.wait([
      activityNotifier.getAll(
        filter: ActivityFilter(disciplineId: widget.disciplineId),
      ),
      activityNotifier.getAll(
        filter: ActivityFilter(
          disciplineId: widget.disciplineId,
          statuses: <ActivityStatus>[
            ActivityStatus.pending,
            ActivityStatus.inProgress,
          ],
        ),
      ),
      activityNotifier.getAll(
        filter: ActivityFilter(
          disciplineId: widget.disciplineId,
          statuses: <ActivityStatus>[ActivityStatus.completed],
        ),
      ),
      activityNotifier.getAll(
        filter: ActivityFilter(
          disciplineId: widget.disciplineId,
          endDate: now.add(const Duration(days: 3)),
          statuses: <ActivityStatus>[
            ActivityStatus.pending,
            ActivityStatus.inProgress,
          ],
        ),
      ),
    ]);
  }

  List<Activity> _unpack(Result<List<Activity>> result) {
    return result.fold(onSuccess: (data) => data, onFailure: (_) => []);
  }

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FutureBuilder<List<Result<List<Activity>>>>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingStateWidget(message: 'Obtendo atividades...');
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const ErrorStateWidget(
            description: 'Erro ao obter as atividades da disciplina',
          );
        }

        final allActivity = _unpack(snapshot.data![0]);
        final activeActivities = _unpack(snapshot.data![1]);
        final completedActivities = _unpack(snapshot.data![2]);
        final urgentActivities = _unpack(snapshot.data![3]);

        if (allActivity.isEmpty) {
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

        return ListView(
          padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 100.0),
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: ActivitiesMetricCardWidget(
                    label: "Ativas",
                    value: activeActivities.length.toString(),
                    icon: Icons.bolt_rounded,
                    color: colorScheme.secondary,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: ActivitiesMetricCardWidget(
                    label: "Concluídas",
                    value: completedActivities.length.toString(),
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
                    urgentActivities.length.toString(),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w900,
                      color: colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
            if (activeActivities.isNotEmpty) ...<Widget>[
              const SizedBox(height: 40.0),
              const _SectionHeader(title: "Prioridade"),
              const SizedBox(height: 16.0),
              ...activeActivities
                  .take(3)
                  .map((activity) => ActivityCardWidget(activity: activity)),
            ],
            const SizedBox(height: 40.0),
            _SectionHeader(
              title: "Todas as Atividades",
              action: ViewAllButtonWidget(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);

                  ref.read(navigationNotifierProvider.notifier).setIndex(2);
                },
              ),
            ),
            const SizedBox(height: 16.0),
            ...allActivity.map(
              (activity) => ActivityCardWidget(activity: activity),
            ),
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
