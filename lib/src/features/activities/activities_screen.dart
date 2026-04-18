import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/core/routes/app_routes.dart';
import 'package:academic_planner/src/core/di/activity_providers.dart';
import 'package:academic_planner/src/core/di/activity_filter_provider.dart';
import 'package:academic_planner/src/core/result/result.dart';

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
import 'package:academic_planner/src/shared/widgets/states/states.dart';

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

  void _onSearchChanged() {
    final currentFilter = ref.read(activityFilterNotifierProvider);

    ref
        .read(activityFilterNotifierProvider.notifier)
        .setFilter(currentFilter.copyWith(search: _searchController.text));
  }

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

  List<ActivityModel> _unpackResult(Result<List<ActivityModel>> result) {
    return result.fold(
      onSuccess: (value) => value,
      onFailure: (_) => <ActivityModel>[],
    );
  }

  Future<List<Result<List<ActivityModel>>>> _fetchAllTabsData(
    ActivityFilter filter,
  ) {
    final controller = ref.read(activityControllerProvider);

    return Future.wait([
      controller.getActivities(filter: filter),
      controller.getActivities(
        filter: filter.copyWith(
          statuses: <ActivityStatus>[
            ActivityStatus.pending,
            ActivityStatus.inProgress,
          ],
        ),
      ),
      controller.getActivities(
        filter: filter.copyWith(
          statuses: <ActivityStatus>[ActivityStatus.completed],
        ),
      ),
      controller.getActivities(
        filter: filter.copyWith(
          statuses: <ActivityStatus>[
            ActivityStatus.draft,
            ActivityStatus.canceled,
          ],
        ),
      ),
    ]);
  }

  @override
  void initState() {
    super.initState();

    _searchController.addListener(_onSearchChanged);
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

    ref.listen(
      activityFilterNotifierProvider,
      (_, next) => _syncTabWithFilter(next),
    );

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
          onPressed: () => AppRoutes.goToActivityForm(context),
          icon: Icons.add_rounded,
        ),
      ),
      body: Column(
        children: <Widget>[
          _buildHeader(colorScheme),
          Expanded(
            child: FutureBuilder<List<Result<List<ActivityModel>>>>(
              future: _fetchAllTabsData(filterState),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingStateWidget();
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return ErrorStateWidget(
                    description: "Não foi possível carregar suas atividades.",
                    actionLabel: "Tentar novamente",
                    onActionPressed: () => setState(() {}),
                  );
                }

                final results = snapshot.data!;
                final allTasks = _unpackResult(results[0]);
                final activeTasks = _unpackResult(results[1]);
                final completedTasks = _unpackResult(results[2]);
                final otherTasks = _unpackResult(results[3]);

                return TabBarView(
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
                );
              },
            ),
          ),
          const SizedBox(height: 52.0),
        ],
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Container(
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
    );
  }
}
