import 'package:flutter/foundation.dart';

import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/features/activity/data/data_source/activity_local_datasource.dart';
import 'package:academic_planner/src/features/activity/data/dtos/activity_dto.dart';
import 'package:academic_planner/src/features/activity/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activity/domain/value_objects/activity_filter.dart';
import 'package:academic_planner/src/features/activity/domain/repositories/activity_repository.dart';

List<Activity> _map(List<Map<String, dynamic>> data) {
  return data.map((e) => ActivityDto.fromMap(e).toEntity()).toList();
}

class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityLocalDataSource datasource;

  ActivityRepositoryImpl(this.datasource);

  @override
  Future<Result<void>> add(Activity activity) async {
    try {
      await datasource.insert(ActivityDto.fromEntity(activity).toMap());

      return const Success(null);
    } catch (err) {
      return FailureResult(DatabaseFailure(err.toString()));
    }
  }

  @override
  Future<Result<List<Activity>>> getAll({ActivityFilter? filter}) async {
    try {
      final data = await datasource.getAll(filter: filter);
      final activities = await compute(_map, data);

      return Success(activities);
    } catch (err) {
      return FailureResult(DatabaseFailure(err.toString()));
    }
  }

  @override
  Future<Result<int>> count({ActivityFilter? filter}) async {
    try {
      final count = await datasource.count(filter: filter);

      return Success(count);
    } catch (err) {
      return FailureResult(DatabaseFailure(err.toString()));
    }
  }

  @override
  Future<Result<Activity?>> getById(String id) async {
    try {
      final data = await datasource.getById(id);

      if (data == null) return const Success(null);

      return Success(ActivityDto.fromMap(data).toEntity());
    } catch (err) {
      return FailureResult(DatabaseFailure(err.toString()));
    }
  }

  @override
  Future<Result<void>> update(Activity activity) async {
    try {
      await datasource.update(
        activity.id,
        ActivityDto.fromEntity(activity).toMap(),
      );

      return const Success(null);
    } catch (err) {
      return FailureResult(DatabaseFailure(err.toString()));
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      await datasource.delete(id);

      return const Success(null);
    } catch (err) {
      return FailureResult(DatabaseFailure(err.toString()));
    }
  }
}
