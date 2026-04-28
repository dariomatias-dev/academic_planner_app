import 'package:academic_planner/src/core/domain/entities/pagination.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:academic_planner/src/core/logging/logger_service.dart';
import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/domain/repositories/activity_repository.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';

class ActivityViewModel {
  final ActivityRepository repository;
  final LoggerService _logger;

  ActivityViewModel(this.repository, this._logger);

  Future<Result<void>> create(Activity activity) async {
    _logger.info('createActivity started: ${activity.title}');

    try {
      final result = await repository.add(activity);

      _logger.info('createActivity success: ${activity.title}');

      return result;
    } catch (err, stackTrace) {
      _logger.error('createActivity error', error: err, stackTrace: stackTrace);

      rethrow;
    }
  }

  Future<Result<List<Activity>>> getAll({ActivityFilter? filter}) async {
    _logger.info('getActivities started');

    try {
      final result = await repository.getAll(filter: filter, pagination: Pagination());

      _logger.info('getActivities success');

      return result;
    } catch (err, stackTrace) {
      _logger.error('getActivities error', error: err, stackTrace: stackTrace);

      rethrow;
    }
  }

  Future<Result<int>> count({ActivityFilter? filter}) async {
    _logger.info('countActivities started');

    try {
      final result = await repository.count(filter: filter);

      _logger.info('countActivities success');

      return result;
    } catch (err, stackTrace) {
      _logger.error(
        'countActivities error',
        error: err,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  Future<Result<Activity?>> getById(String id) async {
    _logger.info('getById started: $id');

    try {
      final result = await repository.getById(id);

      _logger.info('getById success: $id');

      return result;
    } catch (err, stackTrace) {
      _logger.error('getById error', error: err, stackTrace: stackTrace);

      rethrow;
    }
  }

  Future<Result<void>> update(Activity activity) async {
    _logger.info('update started: ${activity.id}');

    try {
      final updated = activity.copyWith(updatedAt: DateTime.now());

      final result = await repository.update(updated);

      _logger.info('update success: ${activity.id}');

      return result;
    } catch (err, stackTrace) {
      _logger.error('update error', error: err, stackTrace: stackTrace);

      rethrow;
    }
  }

  Future<Result<void>> delete(String id) async {
    _logger.info('delete started: $id');

    try {
      final result = await repository.delete(id);

      _logger.info('delete success: $id');

      return result;
    } catch (err, stackTrace) {
      _logger.error('delete error', error: err, stackTrace: stackTrace);

      rethrow;
    }
  }

  Activity createNew({
    required String title,
    required String description,
    required int disciplineId,
    required List<String> tags,
    required List<TimeOfDay> reminders,
    required ActivityStatus status,
    String? category,
    DateTime? dueDate,
    String? notes,
  }) {
    final now = DateTime.now();

    _logger.info('createNew activity: $title');

    return Activity(
      id: const Uuid().v7(),
      title: title,
      description: description,
      disciplineId: disciplineId,
      tags: tags,
      reminders: reminders,
      status: status,
      category: category,
      dueDate: dueDate,
      notes: notes,
      createdAt: now,
      updatedAt: now,
    );
  }
}
