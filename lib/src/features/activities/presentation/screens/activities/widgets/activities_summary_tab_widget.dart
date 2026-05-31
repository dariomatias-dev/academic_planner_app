import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/core/domain/entities/pagination.dart';

import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activities/widgets/activities_total_badge_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/widgets/activity_section_header_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/widgets/activity_stats_cards_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/activity_card/activity_card_widget.dart';

import 'package:academic_planner/src/shared/widgets/states/empty_state_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/loading_state_widget.dart';

class ActivitiesSummaryTabWidget extends ConsumerStatefulWidget {
  final ActivityFilter filter;
  final Future<Result<List<Activity>>> Function({
    required ActivityFilter filter,
    required Pagination pagination,
  })
  onFetch;

  const ActivitiesSummaryTabWidget({
    super.key,
    required this.filter,
    required this.onFetch,
  });

  @override
  ConsumerState<ActivitiesSummaryTabWidget> createState() =>
      _ActivitiesSummaryTabWidgetState();
}

class _ActivitiesSummaryTabWidgetState
    extends ConsumerState<ActivitiesSummaryTabWidget>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  final _activities = <Activity>[];

  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentPage = 0;

  static const _limit = 20;

  @override
  bool get wantKeepAlive => true;

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200.0 &&
        !_isLoadingMore &&
        _hasMore &&
        !_isLoading) {
      _fetchMore();
    }
  }

  Future<void> _fetchInitial() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _currentPage = 0;
      _hasMore = true;
    });

    final result = await widget.onFetch(
      filter: widget.filter,
      pagination: const Pagination(page: 0, limit: _limit),
    );

    if (mounted) {
      result.fold(
        onSuccess: (data) {
          setState(() {
            _activities.clear();
            _activities.addAll(data);
            _hasMore = data.length == _limit;
            _isLoading = false;
          });
        },
        onFailure: (_) => setState(() => _isLoading = false),
      );
    }
  }

  Future<void> _fetchMore() async {
    if (_isLoadingMore) return;

    setState(() => _isLoadingMore = true);

    final nextPage = _currentPage + 1;
    final result = await widget.onFetch(
      filter: widget.filter,
      pagination: Pagination(page: nextPage, limit: _limit),
    );

    if (mounted) {
      result.fold(
        onSuccess: (data) {
          setState(() {
            _activities.addAll(data);
            _currentPage = nextPage;
            _hasMore = data.length == _limit;
            _isLoadingMore = false;
          });
        },
        onFailure: (_) => setState(() => _isLoadingMore = false),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchInitial();

    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(ActivitiesSummaryTabWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.filter != widget.filter) {
      _fetchInitial();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);
    final statsAsync = ref.watch(activityStatsNotifierProvider);
    final countAsync = ref.watch(activityCountProvider(null));

    ref.listen(activityNotifierProvider, (_, _) => _fetchInitial());

    if (_isLoading) return const LoadingStateWidget();

    final listCount = _activities.length;
    final itemCount = 1 + (listCount == 0 ? 1 : listCount + (_hasMore ? 1 : 0));

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 140.0),
      physics: const BouncingScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ActivitiesTotalBadgeWidget(
                title: "Minhas Atividades",
                subtitle: "Total acumulado",
                state: countAsync,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: ActivityProgressCardWidget(
                      state: statsAsync.whenData((s) => s.progress),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    flex: 2,
                    child: ActivityUrgentCardWidget(
                      state: statsAsync.whenData((s) => s.urgent),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: MetricCardWidget(
                      label: "Ativas",
                      icon: Icons.bolt_rounded,
                      color: theme.colorScheme.secondary,
                      state: statsAsync.whenData((stats) => stats.active),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: MetricCardWidget(
                      label: "Concluídas",
                      icon: Icons.check_circle_rounded,
                      color: Colors.teal,
                      state: statsAsync.whenData((stats) => stats.completed),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40.0),
              const ActivitySectionHeaderWidget(title: "Próximos Prazos"),
              const SizedBox(height: 20.0),
            ],
          );
        }

        if (listCount == 0) {
          return const EmptyStateWidget(
            icon: Icons.celebration_rounded,
            title: 'Sem atividades',
            description: 'Tudo em dia por aqui!',
            isCentered: false,
          );
        }

        final listIndex = index - 1;
        if (listIndex < listCount) {
          return ActivityCardWidget(activity: _activities[listIndex]);
        }

        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 32.0),
          child: Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
        );
      },
    );
  }
}
