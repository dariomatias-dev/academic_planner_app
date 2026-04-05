import 'package:logger/logger.dart';

import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/data/datasource/activity_local_datasource.dart';
import 'package:academic_planner/src/data/dtos/activity_dto.dart';
import 'package:academic_planner/src/data/repositories/activity/activity_repository.dart';

import 'package:academic_planner/src/shared/models/activity_model.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityLocalDataSource datasource;

  final _logger = Logger();

  ActivityRepositoryImpl(this.datasource);

  @override
  Future<Result<List<ActivityModel>>> getActivities() async {
    try {
      final data = await datasource.getAll();

      final activities = data.builder(
        (e, index) => ActivityDto.fromMap(e).toEntity(),
      );

      _logger.i('Retrieved ${activities.length} activities');

      return Success(activities);
    } catch (err, stackTrace) {
      _logger.e('Error getting activities', error: err, stackTrace: stackTrace);

      return FailureResult(DatabaseFailure(err.toString()));
    }
  }

  @override
  Future<Result<ActivityModel>> getActivityById(String id) async {
    try {
      final data = await datasource.getById(id);

      if (data == null) {
        _logger.w('Activity not found with id $id');

        return FailureResult(DatabaseFailure('Activity not found'));
      }

      final activity = ActivityDto.fromMap(data).toEntity();

      _logger.i('Retrieved activity with id $id');

      return Success(activity);
    } catch (err, stackTrace) {
      _logger.e(
        'Error getting activity by id $id',
        error: err,
        stackTrace: stackTrace,
      );

      return FailureResult(DatabaseFailure(err.toString()));
    }
  }

  @override
  Future<Result<void>> addActivity(ActivityModel activity) async {
    try {
      final dto = ActivityDto.fromEntity(activity);

      await datasource.insert(dto.toMap());

      _logger.i('Inserted activity with id ${activity.id}');

      return const Success(null);
    } catch (err, stackTrace) {
      _logger.e('Error inserting activity', error: err, stackTrace: stackTrace);

      return FailureResult(DatabaseFailure(err.toString()));
    }
  }

  @override
  Future<Result<void>> updateActivity(ActivityModel activity) async {
    try {
      final dto = ActivityDto.fromEntity(activity);

      await datasource.update(activity.id, dto.toMap());

      _logger.i('Updated activity with id ${activity.id}');

      return const Success(null);
    } catch (err, stackTrace) {
      _logger.e(
        'Error updating activity with id ${activity.id}',
        error: err,
        stackTrace: stackTrace,
      );

      return FailureResult(DatabaseFailure(err.toString()));
    }
  }

  @override
  Future<Result<void>> deleteActivity(String id) async {
    try {
      await datasource.delete(id);

      _logger.i('Deleted activity with id $id');

      return const Success(null);
    } catch (err, stackTrace) {
      _logger.e(
        'Error deleting activity with id $id',
        error: err,
        stackTrace: stackTrace,
      );

      return FailureResult(DatabaseFailure(err.toString()));
    }
  }
}
