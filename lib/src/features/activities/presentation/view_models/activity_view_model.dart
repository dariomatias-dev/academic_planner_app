import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/domain/repositories/activity_repository.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';

import 'package:academic_planner/src/shared/utils/app_logger.dart';

class ActivityViewModel {
  final ActivityRepository repository;

  ActivityViewModel(this.repository);

  Future<Result<void>> create(Activity activity) async {
    AppLogger.info('createActivity started: ${activity.title}');

    try {
      final result = await repository.add(activity);

      AppLogger.info('createActivity success: ${activity.title}');

      return result;
    } catch (err, stackTrace) {
      AppLogger.error('createActivity error', err, stackTrace);

      rethrow;
    }
  }

  Future<Result<List<Activity>>> getAll({ActivityFilter? filter}) async {
    AppLogger.info('getActivities started');

    try {
      final result = await repository.getAll(filter: filter);

      AppLogger.info('getActivities success');

      return result;
    } catch (err, stackTrace) {
      AppLogger.error('getActivities error', err, stackTrace);

      rethrow;
    }
  }

  Future<Result<int>> count({ActivityFilter? filter}) async {
    AppLogger.info('countActivities started');

    try {
      final result = await repository.count(filter: filter);

      AppLogger.info('countActivities success');

      return result;
    } catch (err, stackTrace) {
      AppLogger.error('countActivities error', err, stackTrace);

      rethrow;
    }
  }

  Future<Result<Activity?>> getById(String id) async {
    AppLogger.info('getById started: $id');

    try {
      final result = await repository.getById(id);

      AppLogger.info('getById success: $id');

      return result;
    } catch (err, stackTrace) {
      AppLogger.error('getById error', err, stackTrace);

      rethrow;
    }
  }

  Future<Result<void>> update(Activity activity) async {
    AppLogger.info('update started: ${activity.id}');

    try {
      final updated = activity.copyWith(updatedAt: DateTime.now());

      final result = await repository.update(updated);

      AppLogger.info('update success: ${activity.id}');

      return result;
    } catch (err, stackTrace) {
      AppLogger.error('update error', err, stackTrace);

      rethrow;
    }
  }

  Future<Result<void>> delete(String id) async {
    AppLogger.info('delete started: $id');

    try {
      final result = await repository.delete(id);

      AppLogger.info('delete success: $id');

      return result;
    } catch (err, stackTrace) {
      AppLogger.error('delete error', err, stackTrace);

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

    AppLogger.info('createNew activity: $title');

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
