import 'package:academic_planner/src/core/domain/entities/pagination.dart';
import 'package:academic_planner/src/core/result/exception_mapper.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/activities/data/data_source/activity_local_datasource.dart';
import 'package:academic_planner/src/features/activities/data/models/activity_model.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/domain/repositories/activity_repository.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';
import 'package:flutter/foundation.dart';

List<Activity> _map(List<Map<String, dynamic>> data) {
  return data.map((e) => ActivityModel.fromMap(e).toEntity()).toList();
}

class ActivityRepositoryImpl implements ActivityRepository {
  ActivityRepositoryImpl(this.datasource);

  final ActivityLocalDataSource datasource;

  @override
  Future<Result<void>> add(Activity activity) async {
    try {
      await datasource.insert(ActivityModel.fromEntity(activity).toMap());

      return const Success(null);
    } on Exception catch (err) {
      return Failure(ExceptionMapper.mapDatabase(err));
    }
  }

  @override
  Future<Result<List<Activity>>> getAll({
    ActivityFilter? filter,
    Pagination? pagination,
  }) async {
    try {
      final data = await datasource.getAll(
        filter: filter,
        pagination: pagination,
      );

      final activities = await compute(_map, data);

      return Success(activities);
    } on Exception catch (err) {
      return Failure(ExceptionMapper.mapDatabase(err));
    }
  }

  @override
  Future<Result<int>> count({ActivityFilter? filter}) async {
    try {
      final count = await datasource.count(filter: filter);

      return Success(count);
    } on Exception catch (err) {
      return Failure(ExceptionMapper.mapDatabase(err));
    }
  }

  @override
  Future<Result<Activity?>> getById(String id) async {
    try {
      final data = await datasource.getById(id);

      if (data == null) return const Success(null);

      return Success(ActivityModel.fromMap(data).toEntity());
    } on Exception catch (err) {
      return Failure(ExceptionMapper.mapDatabase(err));
    }
  }

  @override
  Future<Result<void>> update(Activity activity) async {
    try {
      await datasource.update(
        activity.id,
        ActivityModel.fromEntity(activity).toMap(),
      );

      return const Success(null);
    } on Exception catch (err) {
      return Failure(ExceptionMapper.mapDatabase(err));
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      await datasource.delete(id);

      return const Success(null);
    } on Exception catch (err) {
      return Failure(ExceptionMapper.mapDatabase(err));
    }
  }

  @override
  Future<Result<void>> deleteAll() async {
    try {
      await datasource.deleteAll();

      return const Success(null);
    } on Exception catch (err) {
      return Failure(ExceptionMapper.mapDatabase(err));
    }
  }
}
