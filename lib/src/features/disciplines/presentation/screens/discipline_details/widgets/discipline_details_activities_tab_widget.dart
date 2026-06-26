import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';
import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/activity_card/activity_card_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/activity_section_header_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/activity_stats_cards_widget.dart';
import 'package:academic_planner/src/shared/widgets/buttons/view_all_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final FutureProvider<List<List<Activity>>> Function(int)
disciplineActivitiesProvider = FutureProvider.family<List<List<Activity>>, int>(
  (ref, disciplineId) async {
    ref.watch(activityNotifierProvider);

    final activityNotifier = ref.read(activityNotifierProvider.notifier);
    final now = DateTime.now();

    final results = await Future.wait([
      activityNotifier.getAll(
        filter: ActivityFilter(disciplineId: disciplineId),
      ),
      activityNotifier.getAll(
        filter: ActivityFilter(
          disciplineId: disciplineId,
          statuses: [
            ActivityStatus.pending,
            ActivityStatus.inProgress,
          ],
        ),
      ),
      activityNotifier.getAll(
        filter: ActivityFilter(
          disciplineId: disciplineId,
          statuses: [ActivityStatus.completed],
        ),
      ),
      activityNotifier.getAll(
        filter: ActivityFilter(
          disciplineId: disciplineId,
          endDate: now.add(const Duration(days: 3)),
          statuses: [
            ActivityStatus.pending,
            ActivityStatus.inProgress,
          ],
        ),
      ),
    ]);

    return results.builder((r, index) {
      return r.fold(
        onSuccess: (data) => data,
        onFailure: (_) => [],
      );
    });
  },
);

class DisciplineDetailsActivitiesTabWidget extends ConsumerWidget {
  const DisciplineDetailsActivitiesTabWidget({
    required this.disciplineId,
    super.key,
  });

  final int disciplineId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(activityNotifierProvider, (_, _) {
      ref.invalidate(disciplineActivitiesProvider(disciplineId));
    });

    final asyncData = ref.watch(disciplineActivitiesProvider(disciplineId));
    final theme = Theme.of(context);

    return asyncData.when(
      loading: () {
        return const LoadingStateWidget(message: 'Obtendo atividades...');
      },
      error: (_, _) {
        return const ErrorStateWidget(
          description: 'Erro ao obter as atividades',
        );
      },
      data: (data) {
        final all = data[0];
        final active = data[1];
        final completed = data[2];
        final urgent = data[3];

        if (all.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.assignment_outlined,
            title: 'Sem atividades',
            description: 'Nenhuma atividade criada para esta disciplina.',
            actionLabel: 'Criar Atividade',
            onActionPressed: () async {
              await AppRoutes.goToActivityForm(
                context,
                disciplineId: disciplineId,
              );
            },
          );
        }

        final progress = all.isEmpty ? 0.0 : completed.length / all.length;

        return ListView(
          padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 100.0),
          physics: const BouncingScrollPhysics(),
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ActivityProgressCardWidget(
                    state: AsyncValue.data(progress),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  flex: 2,
                  child: ActivityUrgentCardWidget(
                    state: AsyncValue.data(urgent.length),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: MetricCardWidget(
                    label: 'Ativas',
                    value: active.length.toString(),
                    icon: Icons.bolt_rounded,
                    color: theme.colorScheme.secondary,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: MetricCardWidget(
                    label: 'Concluídas',
                    value: completed.length.toString(),
                    icon: Icons.check_circle_rounded,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
            if (active.isNotEmpty) ...[
              const SizedBox(height: 40.0),
              const ActivitySectionHeaderWidget(title: 'Prioridade'),
              const SizedBox(height: 16.0),
              ...active.map(
                (activity) => ActivityCardWidget(activity: activity),
              ),
            ],
            const SizedBox(height: 40.0),
            ActivitySectionHeaderWidget(
              title: 'Todas as Atividades',
              action: ViewAllButtonWidget(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);

                  AppRoutes.goToActivities(context);
                },
              ),
            ),
            const SizedBox(height: 16.0),
            ...all.map((activity) => ActivityCardWidget(activity: activity)),
          ],
        );
      },
    );
  }
}
