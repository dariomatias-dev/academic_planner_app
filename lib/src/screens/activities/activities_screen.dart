import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/constants/mock_activities.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';

import 'package:academic_planner/src/screens/activities/widgets/activities_date_indicator_widget.dart';

import 'package:academic_planner/src/shared/models/activity_model.dart';
import 'package:academic_planner/src/shared/widgets/activity_card_widget.dart';
import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/input_widget.dart';
import 'package:academic_planner/src/shared/widgets/tab_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/buttons/notification_button_widget.dart';

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
      if (a.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;

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
        title: "Atividades",
        showBackButton: false,
        actions: <Widget>[
          IconButtonWidget(icon: Icons.filter_list_rounded, onPressed: () {}),
          const NotificationButtonWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppRoutes.goToCreateTask(context, disciplineId: 0);
        },
        backgroundColor: colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Icon(
          Icons.add_rounded,
          color: colorScheme.onPrimary,
          size: 24.0,
        ),
      ),
      bottomNavigationBar: const SizedBox(height: 110.0),
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
                _SummaryTab(tasks: _getFilteredTasks()),
                _TaskListTab(
                  tasks: _getFilteredTasks(
                    allowedStatuses: <ActivityStatus>[
                      ActivityStatus.pending,
                      ActivityStatus.inProgress,
                    ],
                  ),
                  description: "Tarefas em andamento ou pendentes",
                  emptyMessage: "Foco total! Nenhuma tarefa ativa no momento.",
                ),
                _TaskListTab(
                  tasks: _getFilteredTasks(
                    allowedStatuses: <ActivityStatus>[ActivityStatus.completed],
                  ),
                  description: "Histórico de atividades finalizadas",
                  emptyMessage: "O histórico está vazio. Vamos começar?",
                ),
                _TaskListTab(
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
        ],
      ),
    );
  }
}

class _SummaryTab extends StatelessWidget {
  final List<ActivityModel> tasks;

  const _SummaryTab({required this.tasks});

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
              child: _MetricCard(
                label: "Ativas",
                value: pending.toString(),
                icon: Icons.bolt_rounded,
                color: colorScheme.secondary,
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: _MetricCard(
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
          const _EmptyState(
            icon: Icons.celebration_rounded,
            message: "Tudo em dia por aqui!",
          )
        else
          ...tasks
              .where((t) => t.status != ActivityStatus.completed)
              .take(3)
              .map((task) => ActivityCardWidget(task: task)),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(100)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20.0),
          ),
          const SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withAlpha(140),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 24.0),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(28.0),
          border: Border.all(
            color: Theme.of(context).dividerTheme.color ?? Colors.transparent,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 44.0, color: colorScheme.primary.withAlpha(80)),
            const SizedBox(height: 16.0),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                color: colorScheme.onSurface.withAlpha(140),
                fontWeight: FontWeight.w600,
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskListTab extends StatelessWidget {
  final List<ActivityModel> tasks;
  final String description;
  final String emptyMessage;

  const _TaskListTab({
    required this.tasks,
    required this.description,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
          child: Text(
            description.toUpperCase(),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.0,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
              color: colorScheme.primary.withAlpha(180),
            ),
          ),
        ),
        Expanded(
          child: tasks.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: _EmptyState(
                    icon: Icons.inventory_2_outlined,
                    message: emptyMessage,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 140.0),
                  physics: const BouncingScrollPhysics(),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) =>
                      ActivityCardWidget(task: tasks[index]),
                ),
        ),
      ],
    );
  }
}
