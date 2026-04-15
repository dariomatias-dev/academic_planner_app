import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/core/providers/activity_providers.dart';
import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/data/filters/activity_filter.dart';
import 'package:academic_planner/src/data/repositories/activity/activity_repository.dart';

import 'package:academic_planner/src/shared/models/activity_model.dart';

class ActivityNotifier extends AsyncNotifier<List<ActivityModel>> {
  ActivityRepository get _repository => ref.read(activityRepositoryProvider);

  @override
  Future<List<ActivityModel>> build() async {
    return _fetchActivities();
  }

  Future<List<ActivityModel>> _fetchActivities({ActivityFilter? filter}) async {
    final result = await _repository.getActivities(filter: filter);

    return result.fold(
      onSuccess: (data) => data,
      onFailure: (failure) => throw failure,
    );
  }

  Future<void> refresh({ActivityFilter? filter}) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => _fetchActivities(filter: filter));
  }

  Future<Result<void>> _performMutation(
    Future<Result<void>> Function() action,
  ) async {
    final result = await action();

    return result.fold(
      onSuccess: (_) async {
        ref.invalidateSelf();

        await future;

        return const Success(null);
      },
      onFailure: (failure) => FailureResult(failure),
    );
  }

  Future<Result<void>> addActivity(ActivityModel activity) {
    return _performMutation(() => _repository.addActivity(activity));
  }

  Future<Result<void>> updateActivity(ActivityModel activity) {
    return _performMutation(() => _repository.updateActivity(activity));
  }

  Future<Result<void>> deleteActivity(String id) {
    return _performMutation(() => _repository.deleteActivity(id));
  }

  Future<Result<ActivityModel?>> getActivityById(String id) {
    return _repository.getActivityById(id);
  }

  Future<Result<List<ActivityModel>>> getActivities({
    ActivityFilter? filter,
  }) async {
    final result = await _repository.getActivities(filter: filter);

    return result.fold(
      onSuccess: (data) {
        state = AsyncData(data);

        return Success(data);
      },
      onFailure: (failure) => FailureResult(failure),
    );
  }
}
