import 'package:academic_planner/src/core/domain/entities/pagination.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';

abstract class ActivityRepository {
  Future<Result<void>> add(Activity activity);

  Future<Result<List<Activity>>> getAll({
    ActivityFilter? filter,
    Pagination? pagination,
  });

  Future<Result<int>> count({ActivityFilter? filter});

  Future<Result<Activity?>> getById(String id);

  Future<Result<void>> update(Activity activity);

  Future<Result<void>> delete(String id);

  Future<Result<void>> deleteAll();
}
