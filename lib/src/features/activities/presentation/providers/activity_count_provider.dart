import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';

final activityCountProvider = FutureProvider.family<int, ActivityFilter?>((
  ref,
  filter,
) async {
  ref.watch(activityNotifierProvider);

  final result = await ref
      .read(activityNotifierProvider.notifier)
      .count(filter: filter);

  return result.fold(onSuccess: (count) => count, onFailure: (_) => 0);
});
