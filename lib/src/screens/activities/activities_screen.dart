import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:academic_planner/src/controllers/activity_controller.dart';

import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';

import 'package:academic_planner/src/notifiers/activity_filter_notifier.dart';

import 'package:academic_planner/src/screens/activities/widgets/activities_date_indicator_widget.dart';
import 'package:academic_planner/src/screens/activities/widgets/activities_summary_tab/activities_summary_tab_widget.dart';
import 'package:academic_planner/src/screens/activities/widgets/activities_task_list_tab_widget.dart';

import 'package:academic_planner/src/shared/models/activity_model.dart';
import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/buttons/floating_action_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/buttons/notification_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/input_widget.dart';
import 'package:academic_planner/src/shared/widgets/tab_bar_widget.dart';

class ActivitiesScreenWidget extends StatefulWidget {
  const ActivitiesScreenWidget({super.key});

  @override
  State<ActivitiesScreenWidget> createState() => _ActivitiesScreenWidgetState();
}

class _ActivitiesScreenWidgetState extends State<ActivitiesScreenWidget>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final _activityController = context.read<ActivityController>();
  late final _tabController = TabController(length: 4, vsync: this);
  final _searchController = TextEditingController();

  late final Future _activitiesFuture;

  String _searchQuery = "";

  @override
  bool get wantKeepAlive => true;

  List<ActivityModel> _getFilteredTasks({
    required List<ActivityModel> activities,
    required ActivityFilterNotifier filter,
  }) {
    final filtered = activities.filter((task) {
      final matchesSearch =
          task.title.toLowerCase().contains(_searchQuery) ||
          task.description.toLowerCase().contains(_searchQuery);

      final matchesStatus =
          filter.filter.status == null || filter.filter.status == task.status;

      return matchesSearch && matchesStatus;
    });

    filtered.sort((a, b) {
      if (a.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;

      return a.dueDate!.compareTo(b.dueDate!);
    });

    return filtered;
  }

  void _syncTabWithFilter(ActivityFilterNotifier filter) {
    final status = filter.filter.status;

    int targetIndex = 0;

    if (status == ActivityStatus.pending ||
        status == ActivityStatus.inProgress) {
      targetIndex = 1;
    } else if (status == ActivityStatus.completed) {
      targetIndex = 2;
    } else if (status == ActivityStatus.draft ||
        status == ActivityStatus.canceled) {
      targetIndex = 3;
    }

    if (_tabController.index != targetIndex) {
      _tabController.animateTo(targetIndex);
    }
  }

  @override
  void initState() {
    super.initState();

    _activitiesFuture = _activityController.getActivities();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
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

    final filter = context.watch<ActivityFilterNotifier>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncTabWithFilter(filter);
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: "Atividades",
        showBackButton: false,
        actions: <Widget>[
          IconButtonWidget(icon: Icons.filter_list_rounded, onPressed: () {}),
          const NotificationButtonWidget(),
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
      body: FutureBuilder(
        future: _activitiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final result = snapshot.data;

          final activities =
              result?.fold(
                onSuccess: (list) => list,
                onFailure: (_) => <ActivityModel>[],
              ) ??
              <ActivityModel>[];

          final filteredTasks = _getFilteredTasks(
            activities: activities,
            filter: filter,
          );

          final activeTasks = filteredTasks.filter(
            (task) =>
                task.status == ActivityStatus.pending ||
                task.status == ActivityStatus.inProgress,
          );

          final completedTasks = filteredTasks.filter(
            (task) => task.status == ActivityStatus.completed,
          );

          final otherTasks = filteredTasks.filter(
            (task) =>
                task.status == ActivityStatus.draft ||
                task.status == ActivityStatus.canceled,
          );

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
                    ActivitiesSummaryTabWidget(tasks: filteredTasks),
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
