import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity_stats.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActivityStatsNotifier extends AsyncNotifier<ActivityStats> {
  @override
  Future<ActivityStats> build() async => _load();

  Future<ActivityStats> _load() async {
    final activityNotifier = ref.read(activityNotifierProvider.notifier);

    final now = DateTime.now();

    const activeFilter = ActivityFilter(
      statuses: [
        ActivityStatus.pending,
        ActivityStatus.inProgress,
      ],
    );

    const completedFilter = ActivityFilter(
      statuses: [ActivityStatus.completed],
    );

    final urgentFilter = ActivityFilter(
      statuses: const [
        ActivityStatus.pending,
        ActivityStatus.inProgress,
      ],
      dueBefore: now.add(const Duration(days: 3)),
    );

    final results = await Future.wait([
      activityNotifier.count(),
      activityNotifier.count(filter: activeFilter),
      activityNotifier.count(filter: completedFilter),
      activityNotifier.count(filter: urgentFilter),
    ]);

    final total = results[0].fold(onSuccess: (v) => v, onFailure: (_) => 0);

    final active = results[1].fold(onSuccess: (v) => v, onFailure: (_) => 0);

    final completed = results[2].fold(onSuccess: (v) => v, onFailure: (_) => 0);

    final urgent = results[3].fold(onSuccess: (v) => v, onFailure: (_) => 0);

    final progress = total == 0 ? 0.0 : completed / total;

    return ActivityStats(
      total: total,
      active: active,
      completed: completed,
      urgent: urgent,
      progress: progress,
    );
  }

  Future<void> refresh() async {
    if (state.isLoading) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }
}
