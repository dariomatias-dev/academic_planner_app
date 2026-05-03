import 'package:academic_planner/src/features/activities/presentation/providers/activity_count_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/core/domain/entities/pagination.dart';

import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activities/widgets/activities_total_badge_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/activity_card/activity_card_widget.dart';

import 'package:academic_planner/src/shared/widgets/states/empty_state_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/loading_state_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/error_state_widget.dart';

class ActivitiesTaskListTabWidget extends ConsumerStatefulWidget {
  final String description;
  final String emptyMessage;
  final ActivityFilter filter;
  final Future<Result<List<Activity>>> Function({
    required ActivityFilter filter,
    required Pagination pagination,
  })
  onFetch;

  const ActivitiesTaskListTabWidget({
    super.key,
    required this.description,
    required this.emptyMessage,
    required this.filter,
    required this.onFetch,
  });

  @override
  ConsumerState<ActivitiesTaskListTabWidget> createState() =>
      _ActivitiesTaskListTabWidgetState();
}

class _ActivitiesTaskListTabWidgetState
    extends ConsumerState<ActivitiesTaskListTabWidget>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  final _activities = <Activity>[];

  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasError = false;
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
      _hasError = false;
      _currentPage = 0;
      _hasMore = true;
    });

    final result = await widget.onFetch(
      filter: widget.filter,
      pagination: const Pagination(page: 0, limit: _limit),
    );

    if (!mounted) return;

    result.fold(
      onSuccess: (data) {
        setState(() {
          _activities.clear();
          _activities.addAll(data);
          _hasMore = data.length == _limit;
          _isLoading = false;
        });
      },
      onFailure: (_) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      },
    );
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
  void didUpdateWidget(ActivitiesTaskListTabWidget oldWidget) {
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

    final countAsync = ref.watch(activityCountProvider(widget.filter));

    ref.listen(activityNotifierProvider, (_, _) => _fetchInitial());

    if (_isLoading) return const LoadingStateWidget();

    if (_hasError && _activities.isEmpty) {
      return ErrorStateWidget(
        description: "Erro ao carregar atividades.",
        actionLabel: "Tentar novamente",
        onActionPressed: _fetchInitial,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 0.0),
          child: ActivitiesTotalBadgeWidget(
            title: "Atividades",
            subtitle: widget.description,
            state: countAsync,
          ),
        ),
        Expanded(
          child: _activities.isEmpty
              ? EmptyStateWidget(
                  icon: Icons.inventory_2_outlined,
                  title: 'Sem atividades',
                  description: widget.emptyMessage,
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 140.0),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _activities.length + (_hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _activities.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32.0),
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2.0),
                        ),
                      );
                    }

                    return ActivityCardWidget(activity: _activities[index]);
                  },
                ),
        ),
      ],
    );
  }
}
