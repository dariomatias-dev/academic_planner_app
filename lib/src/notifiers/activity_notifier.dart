import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/data/filters/activity_filter.dart';
import 'package:academic_planner/src/data/repositories/activity/activity_repository.dart';

import 'package:academic_planner/src/shared/models/activity_model.dart';

class ActivityNotifier extends ChangeNotifier {
  final ActivityRepository repository;

  ActivityNotifier(this.repository);

  final activities = <ActivityModel>[];
  bool loading = false;

  Future<Result<void>> addActivity(ActivityModel activity) async {
    final result = await repository.addActivity(activity);

    return await result.foldAsync(
      onSuccess: (_) async {
        await getActivities();

        return Success(null);
      },
      onFailure: (failure) async {
        return FailureResult(failure);
      },
    );
  }

  Future<Result<List<ActivityModel>>> getActivities({
    ActivityFilter? filter,
  }) async {
    loading = true;
    notifyListeners();

    final result = await repository.getActivities(filter: filter);

    final output = await result.foldAsync<Result<List<ActivityModel>>>(
      onSuccess: (list) async {
        activities
          ..clear()
          ..addAll(list);

        return Success(list);
      },
      onFailure: (failure) async {
        return FailureResult(failure);
      },
    );

    loading = false;
    notifyListeners();

    return output;
  }

  Future<Result<ActivityModel?>> getActivityById(String id) async {
    return await repository.getActivityById(id);
  }

  Future<Result<void>> updateActivity(ActivityModel activity) async {
    final result = await repository.updateActivity(activity);

    return await result.foldAsync(
      onSuccess: (_) async {
        await getActivities();

        return Success(null);
      },
      onFailure: (failure) async {
        return FailureResult(failure);
      },
    );
  }

  Future<Result<void>> deleteActivity(String id) async {
    final result = await repository.deleteActivity(id);

    return await result.foldAsync(
      onSuccess: (_) async {
        await getActivities();

        return Success(null);
      },
      onFailure: (failure) async {
        return FailureResult(failure);
      },
    );
  }
}
