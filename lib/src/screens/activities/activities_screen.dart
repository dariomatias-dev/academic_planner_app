import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/constants/mock_activities.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';

import 'package:academic_planner/src/screens/activities/widgets/activities_date_indicator_widget.dart';
import 'package:academic_planner/src/screens/activities/widgets/activities_summary_tab/activities_summary_tab_widget.dart';
import 'package:academic_planner/src/screens/activities/widgets/activities_task_list_tab_widget.dart';

import 'package:academic_planner/src/shared/models/activity_model.dart';
import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
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
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 4, vsync: this);

  final _searchController = TextEditingController();

  String _searchQuery = "";

  List<ActivityModel> _getFilteredTasks({
    List<ActivityStatus>? allowedStatuses,
  }) {
    final filtered = mockActivities.where((task) {
      final matchesSearch =
          task.title.toLowerCase().contains(_searchQuery) ||
          task.description.toLowerCase().contains(_searchQuery);

      var matchesStatus = true;
      if (allowedStatuses != null) {
        matchesStatus = allowedStatuses.contains(task.status);
      }

      return matchesSearch && matchesStatus;
    }).toList();

    filtered.sort((a, b) {
      if (a.dueDate == null && b.dueDate == null) return 0.0.toInt();
      if (a.dueDate == null) return 1.0.toInt();
      if (b.dueDate == null) return -1.0.toInt();

      return a.dueDate!.compareTo(b.dueDate!);
    });

    return filtered;
  }

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });

    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        label: 'Estudante',
        title: "Atividades",
        showBackButton: false,
        actions: <Widget>[
          IconButtonWidget(icon: Icons.filter_list_rounded, onPressed: () {}),
          const NotificationButtonWidget(),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90.0),
        child: FloatingActionButton(
          onPressed: () {
            AppRoutes.goToCreateTask(context, disciplineId: 0);
          },
          backgroundColor: colorScheme.primary,
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Icon(
            Icons.add_rounded,
            color: colorScheme.onPrimary,
            size: 28.0,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: colorScheme.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ActivitiesDateIndicatorWidget(),
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
                ActivitiesSummaryTabWidget(tasks: _getFilteredTasks()),
                ActivitiesTaskListTabWidget(
                  tasks: _getFilteredTasks(
                    allowedStatuses: <ActivityStatus>[
                      ActivityStatus.pending,
                      ActivityStatus.inProgress,
                    ],
                  ),
                  description: "Tarefas em andamento ou pendentes",
                  emptyMessage: "Foco total! Nenhuma tarefa ativa no momento.",
                ),
                ActivitiesTaskListTabWidget(
                  tasks: _getFilteredTasks(
                    allowedStatuses: <ActivityStatus>[ActivityStatus.completed],
                  ),
                  description: "Histórico de atividades finalizadas",
                  emptyMessage: "O histórico está vazio. Vamos começar?",
                ),
                ActivitiesTaskListTabWidget(
                  tasks: _getFilteredTasks(
                    allowedStatuses: <ActivityStatus>[
                      ActivityStatus.draft,
                      ActivityStatus.canceled,
                    ],
                  ),
                  description: "Rascunhos e tarefas canceladas",
                  emptyMessage: "Sem rascunhos ou tarefas canceladas.",
                ),
              ],
            ),
          ),
          const SizedBox(height: 52.0),
        ],
      ),
    );
  }
}
