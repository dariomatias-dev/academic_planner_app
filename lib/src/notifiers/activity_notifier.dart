import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/core/di/activity_providers.dart';
import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/data/filters/activity_filter.dart';
import 'package:academic_planner/src/data/repositories/activity/activity_repository.dart';

import 'package:academic_planner/src/shared/models/activity_model.dart';

class ActivityNotifier extends AsyncNotifier<void> {
  ActivityRepository get _repository => ref.read(activityRepositoryProvider);

  @override
  Future<void> build() async {}

  Future<Result<List<ActivityModel>>> getActivities({ActivityFilter? filter}) {
    return _repository.getActivities(filter: filter);
  }

  Future<Result<int>> countActivities({ActivityFilter? filter}) {
    return _repository.countActivities(filter: filter);
  }

  Future<Result<ActivityModel?>> getActivityById(String id) {
    return _repository.getActivityById(id);
  }

  Future<Result<void>> addActivity(ActivityModel activity) async {
    final result = await _repository.addActivity(activity);

    if (result is Success) {
      ref.invalidateSelf();
    }

    return result;
  }

  Future<Result<void>> updateActivity(ActivityModel activity) async {
    final result = await _repository.updateActivity(activity);

    if (result is Success) {
      ref.invalidateSelf();
    }

    return result;
  }

  Future<Result<void>> deleteActivity(String id) async {
    final result = await _repository.deleteActivity(id);

    if (result is Success) {
      ref.invalidateSelf();
    }

    return result;
  }
}
