import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';

class ActivityFilterNotifier extends Notifier<ActivityFilter> {
  @override
  ActivityFilter build() {
    return const ActivityFilter();
  }

  void setFilter(ActivityFilter filter) {
    state = filter;
  }

  void update({
    String? search,
    int? disciplineId,
    DateTime? startDate,
    DateTime? endDate,
    List<ActivityStatus>? statuses,
  }) {
    state = state.copyWith(
      search: search,
      disciplineId: disciplineId,
      startDate: startDate,
      endDate: endDate,
      statuses: statuses,
    );
  }

  void clear() {
    state = const ActivityFilter();
  }
}
