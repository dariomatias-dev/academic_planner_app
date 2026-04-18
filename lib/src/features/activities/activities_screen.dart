import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/core/routes/app_routes.dart';
import 'package:academic_planner/src/core/di/activity_providers.dart';
import 'package:academic_planner/src/core/di/activity_filter_provider.dart';

import 'package:academic_planner/src/data/filters/activity_filter.dart';

import 'package:academic_planner/src/features/activities/widgets/activities_date_indicator_widget.dart';
import 'package:academic_planner/src/features/activities/widgets/activities_filter_modal_widget.dart';
import 'package:academic_planner/src/features/activities/widgets/activities_summary_tab_widget.dart';
import 'package:academic_planner/src/features/activities/widgets/activities_task_list_tab_widget.dart';

import 'package:academic_planner/src/shared/models/activity_model.dart';
import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/buttons/floating_action_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/buttons/notification_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/inputs/input_widget.dart';
import 'package:academic_planner/src/shared/widgets/tab_bar_widget.dart';

class ActivitiesScreenWidget extends ConsumerStatefulWidget {
  const ActivitiesScreenWidget({super.key});

  @override
  ConsumerState<ActivitiesScreenWidget> createState() =>
      _ActivitiesScreenWidgetState();
}

class _ActivitiesScreenWidgetState extends ConsumerState<ActivitiesScreenWidget>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final TabController _tabController = TabController(
    length: 4,
    vsync: this,
  );

  final _searchController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  void _syncTabWithFilter(ActivityFilter filter) {
    final statuses = filter.statuses;
    if (statuses == null || statuses.isEmpty) return;

    int targetIndex = 0;
    if (statuses.contains(ActivityStatus.pending) ||
        statuses.contains(ActivityStatus.inProgress)) {
      targetIndex = 1;
    } else if (statuses.contains(ActivityStatus.completed)) {
      targetIndex = 2;
    } else if (statuses.contains(ActivityStatus.draft) ||
        statuses.contains(ActivityStatus.canceled)) {
      targetIndex = 3;
    }

    if (_tabController.index != targetIndex) {
      _tabController.animateTo(targetIndex);
    }
  }

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      final currentFilter = ref.read(activityFilterNotifierProvider);

      ref
          .read(activityFilterNotifierProvider.notifier)
          .setFilter(currentFilter.copyWith(search: _searchController.text));
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final filterState = ref.watch(activityFilterNotifierProvider);

    ref.watch(activityNotifierProvider);

    ref.listen(activityFilterNotifierProvider, (_, next) {
      _syncTabWithFilter(next);
    });

    final controller = ref.read(activityControllerProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: "Atividades",
        showBackButton: false,
        actions: <Widget>[
          IconButtonWidget(
            icon: Icons.filter_alt_outlined,
            onPressed: () => ActivitiesFilterModalWidget.show(context),
          ),
          const NotificationButtonWidget(),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90.0),
        child: FloatingActionButtonWidget(
          heroTag: null,
          onPressed: () async => await AppRoutes.goToActivityForm(context),
          icon: Icons.add_rounded,
        ),
      ),
      body: FutureBuilder(
        future: Future.wait([
          controller.getActivities(filter: filterState),
          controller.getActivities(
            filter: filterState.copyWith(
              statuses: <ActivityStatus>[
                ActivityStatus.pending,
                ActivityStatus.inProgress,
              ],
            ),
          ),
          controller.getActivities(
            filter: filterState.copyWith(
              statuses: <ActivityStatus>[ActivityStatus.completed],
            ),
          ),
          controller.getActivities(
            filter: filterState.copyWith(
              statuses: <ActivityStatus>[
                ActivityStatus.draft,
                ActivityStatus.canceled,
              ],
            ),
          ),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final results = snapshot.data ?? [];

          List<ActivityModel> unpack(int index) {
            if (results.length <= index) return <ActivityModel>[];
            return results[index].fold(
              onSuccess: (value) => value,
              onFailure: (_) => <ActivityModel>[],
            );
          }

          final allTasks = unpack(0);
          final activeTasks = unpack(1);
          final completedTasks = unpack(2);
          final otherTasks = unpack(3);

          return Column(
            children: <Widget>[
              Container(
                color: colorScheme.surface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const ActivitiesDateIndicatorWidget(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                      child: InputWidget(
                        controller: _searchController,
                        hint: "Filtrar atividades...",
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: colorScheme.onSurface.withAlpha(100),
                        ),
                      ),
                    ),
                    TabBarWidget(
                      controller: _tabController,
                      tabs: const <Tab>[
                        Tab(text: "Resumo"),
                        Tab(text: "Ativas"),
                        Tab(text: "Concluídas"),
                        Tab(text: "Outras"),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    ActivitiesSummaryTabWidget(tasks: allTasks),
                    ActivitiesTaskListTabWidget(
                      tasks: activeTasks,
                      description: "Ativas",
                      emptyMessage:
                          "Foco total! Nenhuma tarefa ativa no momento.",
                    ),
                    ActivitiesTaskListTabWidget(
                      tasks: completedTasks,
                      description: "Concluídas",
                      emptyMessage:
                          "O histórico está vazio. Toque no + para começar.",
                    ),
                    ActivitiesTaskListTabWidget(
                      tasks: otherTasks,
                      description: "Outras",
                      emptyMessage: "Sem rascunhos ou tarefas canceladas.",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 52.0),
            ],
          );
        },
      ),
    );
  }
}
