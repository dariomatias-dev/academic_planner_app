import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/data/filters/activity_filter.dart';

import 'package:academic_planner/src/shared/models/activity_model.dart';

abstract class ActivityRepository {
  Future<Result<void>> addActivity(ActivityModel activity);

  Future<Result<List<ActivityModel>>> getActivities({ActivityFilter? filter});

  Future<Result<int>> countActivities({ActivityFilter? filter});

  Future<Result<ActivityModel?>> getActivityById(String id);

  Future<Result<void>> updateActivity(ActivityModel activity);

  Future<Result<void>> deleteActivity(String id);
}
