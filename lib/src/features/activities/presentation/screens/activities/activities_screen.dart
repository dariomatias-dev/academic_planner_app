import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/core/routes/app_routes.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/core/domain/entities/pagination.dart';

import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activities/widgets/activities_date_indicator_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activities/widgets/activities_summary_tab_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activities/widgets/activities_task_list_tab_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/filters/activities_filter_modal_widget.dart';

import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/buttons/floating_action_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/inputs/input_widget.dart';
import 'package:academic_planner/src/shared/widgets/tab_bar_widget.dart';

class ActivitiesScreen extends ConsumerStatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  ConsumerState<ActivitiesScreen> createState() =>
      _ActivitiesScreenWidgetState();
}

class _ActivitiesScreenWidgetState extends ConsumerState<ActivitiesScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final _tabController = TabController(length: 4, vsync: this);

  final _searchController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  void _onSearchChanged() {
    final currentFilter = ref.read(activityFilterNotifierProvider);

    ref
        .read(activityFilterNotifierProvider.notifier)
        .setFilter(currentFilter.copyWith(search: _searchController.text));
  }

  Future<Result<List<Activity>>> _fetchActivities({
    required ActivityFilter filter,
    required Pagination pagination,
  }) {
    return ref
        .read(activityNotifierProvider.notifier)
        .getAll(filter: filter, pagination: pagination);
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
            icon: Icons.filter_list,
            onPressed: () {
              ActivitiesFilterModalWidget.show(context);
            },
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90.0),
        child: FloatingActionButtonWidget(
          heroTag: null,
          onPressed: () {
            AppRoutes.goToActivityForm(context);
          },
          icon: Icons.add_rounded,
        ),
      ),
      body: Column(
        children: <Widget>[
          _buildHeader(colorScheme),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                ActivitiesSummaryTabWidget(
                  filter: filterState.copyWith(
                    statuses: <ActivityStatus>[
                      ActivityStatus.pending,
                      ActivityStatus.inProgress,
                    ],
                    dueAfter: DateTime.now(),
                  ),
                  onFetch: _fetchActivities,
                ),
                ActivitiesTaskListTabWidget(
                  description: "Atividades Planejadas e em Execução",
                  emptyMessage: "Foco total! Nenhuma tarefa ativa no momento.",
                  filter: filterState.copyWith(
                    statuses: <ActivityStatus>[
                      ActivityStatus.pending,
                      ActivityStatus.inProgress,
                    ],
                  ),
                  onFetch: _fetchActivities,
                ),
                ActivitiesTaskListTabWidget(
                  description: "Histórico de Atividades Finalizadas",
                  emptyMessage:
                      "O histórico está vazio. Toque no + para começar.",
                  filter: filterState.copyWith(
                    statuses: <ActivityStatus>[ActivityStatus.completed],
                  ),
                  onFetch: _fetchActivities,
                ),
                ActivitiesTaskListTabWidget(
                  description: "Atividades em Rascunho ou Descontinuadas",
                  emptyMessage: "Sem rascunhos ou tarefas canceladas.",
                  filter: filterState.copyWith(
                    statuses: <ActivityStatus>[
                      ActivityStatus.draft,
                      ActivityStatus.canceled,
                    ],
                  ),
                  onFetch: _fetchActivities,
                ),
              ],
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
