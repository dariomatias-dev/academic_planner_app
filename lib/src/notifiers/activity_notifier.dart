import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/data/filters/activity_filter.dart';
import 'package:academic_planner/src/data/repositories/activity/activity_repository.dart';

import 'package:academic_planner/src/shared/models/activity_model.dart';

class ActivityNotifier extends ChangeNotifier {
  final ActivityRepository repository;

  ActivityNotifier(this.repository);

  Future<Result<void>> addActivity(ActivityModel activity) async {
    final result = await repository.addActivity(activity);

    return result.fold(
      onSuccess: (_) {
        notifyListeners();

        return const Success(null);
      },
      onFailure: (failure) => FailureResult(failure),
    );
  }

  Future<Result<List<ActivityModel>>> getActivities({
    ActivityFilter? filter,
  }) async {
    return await repository.getActivities(filter: filter);
  }

  Future<Result<ActivityModel?>> getActivityById(String id) async {
    return await repository.getActivityById(id);
  }

  Future<Result<void>> updateActivity(ActivityModel activity) async {
    final result = await repository.updateActivity(activity);

    return result.fold(
      onSuccess: (_) {
        notifyListeners();

        return const Success(null);
      },
      onFailure: (failure) => FailureResult(failure),
    );
  }

  Future<Result<void>> deleteActivity(String id) async {
    final result = await repository.deleteActivity(id);

    return result.fold(
      onSuccess: (_) {
        notifyListeners();

        return const Success(null);
      },
      onFailure: (failure) => FailureResult(failure),
    );
  }
}
