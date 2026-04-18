import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/features/activity/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activity/domain/value_objects/activity_filter.dart';

abstract class ActivityRepository {
  Future<Result<void>> add(Activity activity);

  Future<Result<List<Activity>>> getAll({ActivityFilter? filter});

  Future<Result<int>> count({ActivityFilter? filter});

  Future<Result<Activity?>> getById(String id);

  Future<Result<void>> update(Activity activity);

  Future<Result<void>> delete(String id);
}
