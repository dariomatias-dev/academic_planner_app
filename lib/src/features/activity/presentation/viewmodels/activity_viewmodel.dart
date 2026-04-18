import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/features/activity/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activity/domain/repositories/activity_repository.dart';
import 'package:academic_planner/src/features/activity/domain/value_objects/activity_filter.dart';

class ActivityViewModel {
  final ActivityRepository repository;

  final Logger _logger = Logger();

  ActivityViewModel(this.repository);

  Future<Result<void>> create(Activity activity) async {
    _logger.i('createActivity started: ${activity.title}');

    try {
      final result = await repository.add(activity);

      _logger.i('createActivity success: ${activity.title}');

      return result;
    } catch (err, stackTrace) {
      _logger.e('createActivity error', error: err, stackTrace: stackTrace);

      rethrow;
    }
  }

  Future<Result<List<Activity>>> getAll({ActivityFilter? filter}) async {
    _logger.i('getActivities started');

    try {
      final result = await repository.getAll(filter: filter);

      _logger.i('getActivities success');

      return result;
    } catch (err, stackTrace) {
      _logger.e('getActivities error', error: err, stackTrace: stackTrace);

      rethrow;
    }
  }

  Future<Result<int>> count({ActivityFilter? filter}) async {
    _logger.i('countActivities started');

    try {
      final result = await repository.count(filter: filter);

      _logger.i('countActivities success');

      return result;
    } catch (err, stackTrace) {
      _logger.e('countActivities error', error: err, stackTrace: stackTrace);

      rethrow;
    }
  }

  Future<Result<Activity?>> getById(String id) async {
    _logger.i('getById started: $id');

    try {
      final result = await repository.getById(id);

      _logger.i('getById success: $id');

      return result;
    } catch (err, stackTrace) {
      _logger.e('getById error', error: err, stackTrace: stackTrace);

      rethrow;
    }
  }

  Future<Result<void>> update(Activity activity) async {
    _logger.i('update started: ${activity.id}');

    try {
      final updated = activity.copyWith(updatedAt: DateTime.now());

      final result = await repository.update(updated);

      _logger.i('update success: ${activity.id}');

      return result;
    } catch (err, stackTrace) {
      _logger.e('update error', error: err, stackTrace: stackTrace);

      rethrow;
    }
  }

  Future<Result<void>> delete(String id) async {
    _logger.i('delete started: $id');

    try {
      final result = await repository.delete(id);

      _logger.i('delete success: $id');

      return result;
    } catch (err, stackTrace) {
      _logger.e('delete error', error: err, stackTrace: stackTrace);

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

    _logger.i('createNew activity: $title');

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
